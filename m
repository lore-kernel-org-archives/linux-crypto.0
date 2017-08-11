From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC v2 13/23] x86/power/64: Adapt assembly for PIE support
Date: Fri, 11 Aug 2017 14:36:18 +0200
Message-ID: <20170811123618.GC16126@amd>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170810172615.51965-14-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
	Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Paul Gortm
To: Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-9337-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20170810172615.51965-14-thgarnie@google.com>
List-Id: linux-crypto.vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2017-08-10 10:26:05, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for t=
he
> kernel to be PIE compatible.
>=20
> Position Independent Executable (PIE) support will allow to extended the
> KASLR randomization range below the -2G memory limit.
>=20
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

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

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmNpMIACgkQMOfwapXb+vJG3ACfVMzKXQzx7J3rvbkT2TBtbrjp
JrUAnR5LW+sxtWmaznI1DNIMBYBOlQXY
=ii2P
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
