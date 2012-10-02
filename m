From: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Tue, 02 Oct 2012 15:07:45 +0100
Message-ID: <23688.1349186865@warthog.procyon.org.uk>
References: <874nmd4d2o.fsf@rustcorp.com.au> <87wqzdnwus.fsf@rustcorp.com.au> <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk> <29451.1348903010@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <874nmd4d2o.fsf@rustcorp.com.au>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> Right.  I think we need to use different names for generated vs supplied
> files

The problem with supplied files is people who do allyesconfig, allmodconfig
and randconfig just to test things finding that their builds break.  The
kernel build magic is not really set up to handle external files like this.  I
suppose make logic can be used to conditionally include stuff that might not
exist.

> BTW, you missed a Signed-off-by: on your "MODSIGN: Use the same digest
> for the autogen key sig as for the module sig" patch.  Please update.

Done.

I've also added a patch to convert the system clock to a struct tm and to
produce a struct tm within the ASN.1 decode and then compare those rather than
time_t values as a way to deal with the validity time overflow problem.  We
may have to be able to handle certificates that we haven't generated that
stretch beyond 2038 (I wonder if we might find such in the UEFI key database
for example.

Another way of dealing with this could be to make mktime() within the kernel
produce a u64 rather than an unsigned long, and then compare those.

David
