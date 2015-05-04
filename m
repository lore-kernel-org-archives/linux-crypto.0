From: Ben Collins <ben.c@servergy.com>
Subject: Re: [PATCH 3.14 73/92] dm crypt: fix deadlock when async crypto algorithm returns -EBUSY
Date: Mon, 4 May 2015 17:40:23 -0400
Message-ID: <A9E50BED-C9DB-4F28-9A27-EBB32D837ADD@servergy.com>
References: <20150502190109.683061482@linuxfoundation.org> <20150502190117.069180534@linuxfoundation.org> <20150504213254.GA27445@debian>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_ADA68B10-4D99-46FF-93E9-4597D9E712AB"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Rabin Vincent <rabin@rab.in>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150504213254.GA27445@debian>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--Apple-Mail=_ADA68B10-4D99-46FF-93E9-4597D9E712AB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On May 4, 2015, at 5:32 PM, Rabin Vincent <rabin@rab.in> wrote:
>=20
> On Sat, May 02, 2015 at 09:03:28PM +0200, Greg Kroah-Hartman wrote:
>> 3.14-stable review patch.  If anyone has any objections, please let =
me know.
>>=20
>> ------------------
>>=20
>> From: Ben Collins <ben.c@servergy.com>
>>=20
>> commit 0618764cb25f6fa9fb31152995de42a8a0496475 upstream.
>=20
> The commit in question was recently merged to mainline and is now =
being
> sent to various stable kernels.  But I think the patch is wrong and =
the
> real problem lies in the Freescale CAAM driver which is described as
> having being tested with.

There may be something quirky with CAAM, yes, but the fact is, the code
in the dm-crypt module was very dissimilar to other drivers performing
the same loop/logic.

I don=E2=80=99t think that this patch, which was deemed correct, should =
be held
up based on lower level logic =E2=80=9Cpossibly=E2=80=9D being partially =
at fault. On the
contrary, I think errors you point out may just be showing the error in
dm-crypt more easily, rather than being the complete problem.

> commit 0618764cb25f6fa9fb31152995de42a8a0496475
> Author: Ben Collins <ben.c@servergy.com>
> Date:   Fri Apr 3 16:09:46 2015 +0000
>=20
>     dm crypt: fix deadlock when async crypto algorithm returns -EBUSY
>=20
>     I suspect this doesn't show up for most anyone because software
>     algorithms typically don't have a sense of being too busy.  =
However,
>     when working with the Freescale CAAM driver it will return -EBUSY =
on
>     occasion under heavy -- which resulted in dm-crypt deadlock.
>=20
>     After checking the logic in some other drivers, the scheme for
>     crypt_convert() and it's callback, kcryptd_async_done(), were not
>     correctly laid out to properly handle -EBUSY or -EINPROGRESS.
>=20
>     Fix this by using the completion for both -EBUSY and -EINPROGRESS. =
 Now
>     crypt_convert()'s use of completion is comparable to
>     af_alg_wait_for_completion().  Similarly, kcryptd_async_done() =
follows
>     the pattern used in af_alg_complete().
>=20
>     Before this fix dm-crypt would lockup within 1-2 minutes running =
with
>     the CAAM driver.  Fix was regression tested against software =
algorithms
>     on PPC32 and x86_64, and things seem perfectly happy there as =
well.
>=20
>     Signed-off-by: Ben Collins <ben.c@servergy.com>
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>     Cc: stable@vger.kernel.org
>=20
> dm-crypt uses CRYPTO_TFM_REQ_MAY_BACKLOG.  This means the the crypto
> driver should internally backlog requests which arrive when the queue =
is
> full and process them later.  Until the crypto hw's queue becomes =
full,
> the driver returns -EINPROGRESS.  When the crypto hw's queue if full,
> the driver returns -EBUSY, and if CRYPTO_TFM_REQ_MAY_BACKLOG is set, =
is
> expected to backlog the request and process it when the hardware has
> queue space.  At the point when the driver takes the request from the
> backlog and starts processing it, it calls the completion function =
with
> a status of -EINPROGRESS.  The completion function is called (for a
> second time, in the case of backlogged requests) with a status/err of =
0
> when a request is done.
>=20
> Crypto drivers for hardware without hardware queueing use the helpers,
> crypto_init_queue(), crypto_enqueue_request(), =
crypto_dequeue_request()
> and crypto_get_backlog() helpers to implement this behaviour =
correctly,
> while others implement this behaviour without these helpers (ccp, for
> example).
>=20
> dm-crypt (before this patch) uses this API correctly.  It queues up as
> many requests as the hw queues will allow (i.e. as long as it gets =
back
> -EINPROGRESS from the request function).  Then, when it sees at least
> one backlogged request (gets -EBUSY), it waits till that backlogged
> request is handled (completion gets called with -EINPROGRESS), and =
then
> continues.  The references to af_alg_wait_for_completion() and
> af_alg_complete() in the commit message are irrelevant because those
> functions only handle one request at a time, unlink dm-crypt.
>=20
> The problem is that the Freescale CAAM driver, which this problem is
> described as being seen on, fails to implement the backlogging =
behaviour
> correctly.  In cam_jr_enqueue(), if the hardware queue is full, it
> simply returns -EBUSY without backlogging the request.  What the
> observed deadlock was is not described in the commit message but it is
> obviously the wait_for_completion() in crypto_convert() where =
dm-crypto
> would wait for the completion being called with -EINPROGRESS in the =
case
> of backlogged requests.  This completion will never be completed due =
to
> the bug in the CAAM driver.
>=20
> What this patch does is that it makes dm-crypt wait for every request,
> even when the driver/hardware queues are not full, which means that
> dm-crypt will never see -EBUSY.  This means that this patch will cause =
a
> performance regression on all crypto drivers which implement the API
> correctly.
>=20
> So, I think this patch should be reverted in mainline and the stable
> kernels where it has been merged, and correct backlog handling should =
be
> implemented in the CAAM driver instead.

=E2=80=94=E2=80=94
Ben Collins
Cyphre Champion
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
VP of Engineering
Servergy, Inc.

--Apple-Mail=_ADA68B10-4D99-46FF-93E9-4597D9E712AB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: Stop snooping around.

iQIcBAEBCAAGBQJVR+dHAAoJEF1aV8ckKyLPlm0P/ROZWwSAqGf0WkxrKVrsjPpb
xUGmogPYzLbuqCicoxEbx2sITRhu1ntK8HAn2GnMtwYWJEaxJJoxciGoF1K9ZCyW
nZFiL7AfiDseDowGPOGIvR5a1+Nm9vK/jiu+6agf/ZIbaQ+wW81IaCWLXjfCRnuP
Cpqiq5OK0ciPnaGiFTBqlSs0OCMIVumEfecZFTMys/IR0RTeFmpYLbewaQMLGxCR
nUMtlG2fYDHVrFtZHAxMzvwXopqfwZjBhfKTA6YWLfquAQUsSExP5oCdKDpP5V5E
25rKJsY91Mama2G0s7e5K1+pl6qH7El+4pbvk0e2bCRJLhRc9qRul4h7Xlu9+KoW
WjxX/sPzXTAE8vxdNw0NhBQJkwx46OlPLDKC3Gvr7CW5mgsoVkKCvHDHabmgfYjF
hqoM58ocUJ3W3WIaBhxp/KthFDm1c01Tn3p18gZgnAQonrCo2fBUbOpll84tsvAA
IycR8wzajCzc18OmaSIGW7B5GqNUsdrwVxK5uU5TGPM5mE1S1EVWlfirD2AfD5+k
utzvwAN7y26Py7Z9H3f65rMAafhmoqZPATCGDvjv+9kw095xRd0ajk9b6Q2hIlIS
SEE+c2OmrY7PYQq7htpMv39/uE6A8jC+ZQgrh2gcBmOSLq5ozFrs0DFpVfpICntW
Gx3m4QpyomHRTPr+ldkO
=+f04
-----END PGP SIGNATURE-----

--Apple-Mail=_ADA68B10-4D99-46FF-93E9-4597D9E712AB--
