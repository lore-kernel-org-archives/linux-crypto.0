From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Tue, 9 Oct 2012 13:55:30 +0300
Message-ID: <CALLzPKZaayux=ocJucr=rrzcDx0DxRxv0xLpkt4ZPVU7pbw0kg@mail.gmail.com>
References: <874nmd4d2o.fsf@rustcorp.com.au>
	<87wqzdnwus.fsf@rustcorp.com.au>
	<87ipay3cof.fsf@rustcorp.com.au>
	<87bogs492s.fsf@rustcorp.com.au>
	<87ehlp30pd.fsf@rustcorp.com.au>
	<5555.1348531649@warthog.procyon.org.uk>
	<8168.1348650575@warthog.procyon.org.uk>
	<16088.1348736905@warthog.procyon.org.uk>
	<27378.1348819793@warthog.procyon.org.uk>
	<29451.1348903010@warthog.procyon.org.uk>
	<23688.1349186865@warthog.procyon.org.uk>
	<87ehlf2l9w.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87ehlf2l9w.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 4, 2012 at 2:22 AM, Rusty Russell <rusty@rustcorp.com.au> w=
rote:
> David Howells <dhowells@redhat.com> writes:
>
>> Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>>> Right.  I think we need to use different names for generated vs sup=
plied
>>> files
>>
>> The problem with supplied files is people who do allyesconfig, allmo=
dconfig
>> and randconfig just to test things finding that their builds break. =
 The
>> kernel build magic is not really set up to handle external files lik=
e this.  I
>> suppose make logic can be used to conditionally include stuff that m=
ight not
>> exist.
>>
>>> BTW, you missed a Signed-off-by: on your "MODSIGN: Use the same dig=
est
>>> for the autogen key sig as for the module sig" patch.  Please updat=
e.
>>
>> Done.
>>
>> I've also added a patch to convert the system clock to a struct tm a=
nd to
>> produce a struct tm within the ASN.1 decode and then compare those r=
ather than
>> time_t values as a way to deal with the validity time overflow probl=
em.  We
>> may have to be able to handle certificates that we haven't generated=
 that
>> stretch beyond 2038 (I wonder if we might find such in the UEFI key =
database
>> for example.
>
> OK, cherry-picked to replace my hack.
>
> It's in linux-next, and I will push in the next two days.
>


http://git.kernel.org/?p=3Dlinux/kernel/git/rusty/linux.git;a=3Dcommit;=
h=3Da15e196c5543d1d2d7f0cd70e62351aeb1f8b871

It breaks bisect..

  CC      kernel/module_signing.o
kernel/module_signing.c: In function =E2=80=98mod_verify_sig=E2=80=99:
kernel/module_signing.c:21:10: error: =E2=80=98ENOKEY=E2=80=99 undeclar=
ed (first use
in this function)
kernel/module_signing.c:21:10: note: each undeclared identifier is
reported only once for each function it appears in
kernel/module_signing.c:22:1: warning: control reaches end of non-void
function [-Wreturn-type]
make[1]: *** [kernel/module_signing.o] Error 1
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....

> Thanks,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
