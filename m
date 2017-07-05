From: "Ulrich Windl" <Ulrich.Windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org>
Subject: Antw: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi:
 ensure RNG is seeded before use
Date: Wed, 05 Jul 2017 09:03:43 +0200
Message-ID: <595C8F4F020000A100026F29@gwsmtp1.uni-regensburg.de>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <2639082.PtrrGWOPPL@positron.chronox.de>
 <1498440189.26123.85.camel@haakon3.risingtidesystems.com>
 <1678474.GnYBdSlWgs@tauon.chronox.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "David Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
 "Eric Biggers" <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 "open-iscsi" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 "Greg Kroah-Hartman" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
 "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>,
 "Ted Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,"Chris Leech" <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 "Lee Duncan" <lduncan-IBi9RG/b67k@public.gmane.org>,
 "Linux Crypto Mailing List" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "target-devel" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "Jason A.Donenfeld" <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>
To: "Nicholas A.Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Return-path: <open-iscsi+bncBC6MFJWO34DBBUU66LFAKGQE7FDIFVY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1678474.GnYBdSlWgs-b2PLbiJbNv8ftSvlWXw0+g@public.gmane.org>
Content-Disposition: inline
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
List-Id: linux-crypto.vger.kernel.org

>>> Stephan M=C3=BCller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org> schrieb am 26.06.2017 um 19:3=
8 in
Nachricht <1678474.GnYBdSlWgs-b2PLbiJbNv8ftSvlWXw0+g@public.gmane.org>:
> Am Montag, 26. Juni 2017, 03:23:09 CEST schrieb Nicholas A. Bellinger:
>=20
> Hi Nicholas,
>=20
>> Hi Stephan, Lee & Jason,
>>=20
>> (Adding target-devel CC')
>>=20
>> Apologies for coming late to the discussion.  Comments below.
>>=20
>> On Sun, 2017-06-18 at 10:04 +0200, Stephan M=C3=BCller wrote:
>> > Am Samstag, 17. Juni 2017, 05:45:57 CEST schrieb Lee Duncan:
>> >=20
>> > Hi Lee,
>> >=20
>> > > In your testing, how long might a process have to wait? Are we talki=
ng
>> > > seconds? Longer? What about timeouts?
>> >=20
>> > In current kernels (starting with 4.8) this timeout should clear withi=
n
a
>> > few seconds after boot.
>> >=20
>> > In older kernels (pre 4.8), my KVM takes up to 90 seconds to reach tha=
t
>> > seeding point. I have heard that on IBM System Z this trigger point
>> > requires minutes to be reached.
>>=20
>> I share the same concern as Lee wrt to introducing latency into the
>> existing iscsi-target login sequence.
>>=20
>> Namely in the use-cases where a single node is supporting ~1K unique
>> iscsi-target IQNs, and fail-over + re-balancing of IQNs where 100s of
>> login attempts are expected to occur in parallel.
>>=20
>> If environments exist that require non trivial amounts of time for RNG
>> seeding to be ready for iscsi-target usage, then enforcing this
>> requirement at iscsi login time can open up problems, especially when
>> iscsi host environments may be sensitive to login timeouts, I/O
>> timeouts, et al.
>>=20
>> That said, I'd prefer to simply wait for RNG to be seeded at modprobe
>> iscsi_target_mod time, instead of trying to enforce randomness during
>> login.
>>=20
>> This way, those of use who have distributed storage platforms can know
>> to avoid putting a node into a state to accept iscsi-target IQN export
>> migration, before modprobe iscsi_target_mod has successfully loaded and
>> RNG seeding has been confirmed.
>>=20
>> WDYT..?
>=20
> We may have a chicken and egg problem when the wait is at the modprobe ti=
me.

>=20
> Assume the modprobe happens during initramfs time to get access to the ro=
ot

> file system. In this case, you entire boot process will lock up for an=20
> indefinite amount of time. The reason is that in order to obtain events=
=20
> detected by the RNG, devices need to be initialized and working. Such=20
> devices=20
> commonly start working after the the root partition is mounted as it=20
> contains=20
> all drivers, all configuration information etc.
>=20
> Note, during the development of my /dev/random implementation, I added th=
e=20
> getrandom-like blocking behavior to /dev/urandom (which is the equivalent=
 to

>=20
> Jason's patch except that it applies to user space). The boot process loc=
ked


I thought reads from urandom never block by definition. An older manual pag=
e
(man urandom) also says: "A  read  from  the  /dev/urandom device will not
block waiting for more entropy."

Regards,
Ulrich

>=20
> up since systemd wanted data from /dev/urandom while it processed the=20
> initramfs. As it did not get any, the boot process did not commence that=
=20
> could=20
> deliver new events to be picked up by the RNG.
>=20
> As I do not have such an iscsi system, I cannot test Jason's patch. But=
=20
> maybe=20
> the mentioned chicken-and-egg problem I mentioned above is already visibl=
e=20
> with the current patch as it will lead to a blocking of the mounting of t=
he

> root partition in case the root partition is on an iscsi target.
>=20
> Ciao
> Stephan
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
=20
> "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
=20
> email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> Visit this group at https://groups.google.com/group/open-iscsi.
> For more options, visit https://groups.google.com/d/optout.



--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
