From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Wed, 10 Oct 2012 20:07:11 +1030
Message-ID: <87ipai7jnc.fsf@rustcorp.com.au>
References: <874nmd4d2o.fsf@rustcorp.com.au> <87wqzdnwus.fsf@rustcorp.com.au> <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk> <29451.1348903010@warthog.procyon.org.uk> <23688.1349186865@warthog.procyon.org.uk> <87ehlf2l9w.fsf@rustcorp.com.au> <CALLzPKZaayux=ocJucr=rrzcDx0DxRxv0xLpkt4ZPVU7pbw0kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALLzPKZaayux=ocJucr=rrzcDx0DxRxv0xLpkt4ZPVU7pbw0kg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

"Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> writes:
> http://git.kernel.org/?p=3Dlinux/kernel/git/rusty/linux.git;a=3Dcommi=
t;h=3Da15e196c5543d1d2d7f0cd70e62351aeb1f8b871
>
> It breaks bisect..
>
>   CC      kernel/module_signing.o
> kernel/module_signing.c: In function =E2=80=98mod_verify_sig=E2=80=99=
:
> kernel/module_signing.c:21:10: error: =E2=80=98ENOKEY=E2=80=99 undecl=
ared (first use
> in this function)
> kernel/module_signing.c:21:10: note: each undeclared identifier is
> reported only once for each function it appears in
> kernel/module_signing.c:22:1: warning: control reaches end of non-voi=
d
> function [-Wreturn-type]
> make[1]: *** [kernel/module_signing.o] Error 1
> make: *** [kernel] Error 2
> make: *** Waiting for unfinished jobs....

Ah, my mistake; missing #include.  I've fixed this which unfortunately
meant a rebase.

Thanks,
Rusty.
