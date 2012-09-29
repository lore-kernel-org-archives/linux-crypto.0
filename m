From: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Sat, 29 Sep 2012 08:16:50 +0100
Message-ID: <29451.1348903010@warthog.procyon.org.uk>
References: <87wqzdnwus.fsf@rustcorp.com.au> <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87wqzdnwus.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> I noticed the Cert number didn't change with rebuilds: "distclean"
> didn't remove some files:
> 
> $ git clean -f -f -x -d
> Removing extra_certificates
> Removing signing_key.priv
> Removing signing_key.x509
> Removing signing_key.x509.keyid
> Removing signing_key.x509.signer
> Removing x509.genkey

I'm not sure whether distclean should remove those, since they can be
externally supplied, or whether x509.genkey should have a Makefile dependency
on kernel/Makefile.

I lean towards 'yes' when I'm altering kernel/Makefile trying to get things
right, and 'no' when I'm doing a make distclean to change my config or
changing kernel/Makefile for some unrelated reason.

David
