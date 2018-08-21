From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: Re: BUG: libkcapi tests trigger sleep-in-atomic bug in VMX code
 (ppc64)
Date: Tue, 21 Aug 2018 12:12:00 -0300
Message-ID: <20180821151200.GD28751@gallifrey>
References: <CAAUqJDvErj0Y4=GBtXgvBRON7MEic7_-jBZNvjacwcOd0TF_2g@mail.gmail.com>
 <3627129.cWTIy1uDMC@tauon.chronox.de>
 <CAAUqJDt_y04ts7Aq0U0fhXYRus2ckkEohBTkga0pjqfoQaBOCA@mail.gmail.com>
 <708f0ba5-6ce2-19e6-1269-ea9a14090694@c-s.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature"; boundary="5p8PegU4iirBW1oA"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Stephan Mueller <smueller@chronox.de>,
 Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
 Paul Mackerras <paulus@samba.org>, linux-crypto@vger.kernel.org,
 Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <708f0ba5-6ce2-19e6-1269-ea9a14090694@c-s.fr>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org


--5p8PegU4iirBW1oA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

CC: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>

Yes, I do believe that CTR is doing it right. Preemption only needs to be
disabled during the aes_p8_cbc_encrypt() call, to avoid trashing the
VSX registers during the AES operation.

--=20
Regards,
Marcelo

On Tue, Aug 21, 2018 at 05:03:50PM +0200, Christophe LEROY wrote:
>=20
>=20
> Le 21/08/2018 =C3=A0 16:38, Ondrej Mosn=C3=A1=C4=8Dek a =C3=A9crit=C2=A0:
> > ut 21. 8. 2018 o 16:18 Stephan Mueller <smueller@chronox.de> nap=C3=ADs=
al(a):
> > > Am Dienstag, 21. August 2018, 14:48:11 CEST schrieb Ondrej Mosn=C3=A1=
=C4=8Dek:
> > >=20
> > > Hi Ondrej, Marcelo,
> > >=20
> > > (+Marcelo)
> > >=20
> > > > Looking at crypto/algif_skcipher.c, I can see that skcipher_recvmsg=
()
> > > > holds the socket lock the whole time and yet passes
> > > > CRYPTO_TFM_REQ_MAY_SLEEP to the cipher implementation. Isn't that
> > > > wrong?
> > >=20
> > > I think you are referring to lock_sock(sk)?
> > >=20
> > > If so, this should not be the culprit: the socket lock is in essence =
a mutex-
> > > like operation with its own wait queue that it allowed to sleep. In
> > > lock_sock_nested that is called by lock_sock it even has the call of
> > > might_sleep which indicates that the caller may be put to sleep.
> > >=20
> > > Looking into the code (without too much debugging) I see in the funct=
ion
> > > p8_aes_cbc_encrypt that is part of the stack trace the call to
> > > preempt_disable() which starts an atomic context. The preempt_enable(=
) is
> > > invoked after the walk operation.
> > >=20
> > > The preempt_disable increases the preempt_count. That counter is used=
 by
> > > in_atomic() to check whether we are in atomic context.
> > >=20
> > > The issue is that blkcipher_walk_done may call crypto_yield() which t=
hen
> > > invokes cond_resched if the implementation is allowed to sleep.
> >=20
> > Indeed, you're right, the issue is actually in the vmx_crypto code. I
> > remember having looked at the 'ctr(aes)' implementation in there a few
> > days ago (I think I was trying to debug this very issue, but for some
> > reason I only looked at ctr(aes)...) and I didn't find any bug, so
> > that's why I jumped to suspecting the algif_skcipher code... I should
> > have double-checked :)
> >=20
> > It turns out the 'cbc(aes)' (and actually also 'xts(aes)')
> > implementation is coded a bit differently and they both *do* contain
> > the sleep-in-atomic bug. I will try to fix them according to the
> > correct CTR implementation and send a patch.
>=20
> CC: linuxppc-dev@lists.ozlabs.org <linuxppc-dev@lists.ozlabs.org>
>=20
> >=20
> > Thanks,
> > Ondrej
> >=20
> > > @Marcelo: shouldn't be the sleep flag be cleared when entering the
> > > preempt_disable section?
> > >=20
> > > Ciao
> > > Stephan
> > >=20
> > >=20

--5p8PegU4iirBW1oA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDWI6S4SUeUOX/xHQzxpLxzTV7UcFAlt8K8AACgkQzxpLxzTV
7Ue3nAf/YyKY6KgeWd3M8jMzNsWBWGl8/cCmHxtrHPa8RcOdMsaajCyJGTLwIkt/
dQCth8WNTCrl36IQ1WY7v4J7jPNb+D4ApqPhNRJgyKZileAfctpKpLadzHc9laIZ
7f92OC/zTvquIcgiDKxTiVWxcck1n7070L0pI9aANMlsRm5L3of0RqgtkAfb2bpW
cEp1NcpF82NI5Qw1ikYNziYhawQ79Qt0Nc67RGrj+NNKpULchFEsQ5g2ubZofYuP
txknzHwuP4cI8VTK0odkdCtQYiBYskd8CADHl2Ycm0/3HawjC7TpsyLfEGNoxARe
wkfpTi5XTL9CzwnY3vk+NJwdDyiMwA==
=bcNb
-----END PGP SIGNATURE-----

--5p8PegU4iirBW1oA--
