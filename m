From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v3 11/27] x86/power/64: Adapt assembly for PIE support
Date: Thu, 24 May 2018 13:03:41 +0200
Message-ID: <20180524110341.GB20225@amd>
References: <20180523195421.180248-1-thgarnie@google.com>
 <20180523195421.180248-12-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Philippe Ombredanne <pombredanne@nexb.com>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Yonghong Song <yhs@fb.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Kees Cook <keescook@chromium.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Juerge
To: Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-13383-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20180523195421.180248-12-thgarnie@google.com>
List-Id: linux-crypto.vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-05-23 12:54:05, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for t=
he
> kernel to be PIE compatible.
>=20
> Position Independent Executable (PIE) support will allow to extended the
> KASLR randomization range below the -2G memory limit.
>=20
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Again, was this tested?

> diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate=
_asm_64.S
> index ce8da3a0412c..6fdd7bbc3c33 100644
> --- a/arch/x86/power/hibernate_asm_64.S
> +++ b/arch/x86/power/hibernate_asm_64.S
> @@ -24,7 +24,7 @@
>  #include <asm/frame.h>
> =20
>  ENTRY(swsusp_arch_suspend)
> -	movq	$saved_context, %rax
> +	leaq	saved_context(%rip), %rax
>  	movq	%rsp, pt_regs_sp(%rax)
>  	movq	%rbp, pt_regs_bp(%rax)
>  	movq	%rsi, pt_regs_si(%rax)
> @@ -115,7 +115,7 @@ ENTRY(restore_registers)
>  	movq	%rax, %cr4;  # turn PGE back on
> =20
>  	/* We don't restore %rax, it must be 0 anyway */
> -	movq	$saved_context, %rax
> +	leaq	saved_context(%rip), %rax
>  	movq	pt_regs_sp(%rax), %rsp
>  	movq	pt_regs_bp(%rax), %rbp
>  	movq	pt_regs_si(%rax), %rsi

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsGnA0ACgkQMOfwapXb+vK3PwCgjIuOx9YZTN3evFcQKm9c41TU
Q4sAoLZgV0pIcRgoHsgk/ecLa/CLhuIR
=YTGF
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
