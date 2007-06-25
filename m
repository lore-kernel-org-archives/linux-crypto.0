From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Date: Tue, 26 Jun 2007 05:23:00 +0530
Message-ID: <a781481a0706251653wa2db7e4geb181f3827a10f9d@mail.gmail.com>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
	 <1182536729847-git-send-email-arw@arw.name>
	 <a781481a0706221236t3b399afdkf2e07cb109fba226@mail.gmail.com>
	 <20070624225809.GI9741@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Alexander Wuerstlein" <arw@arw.name>,
	linux-kernel@vger.kernel.org,
	"Johannes Schlumberger" <spjsschl@stud.informatik.uni-erlangen.de>,
	linux-crypto@vger.kernel.org
To: "Alexander Wuerstlein" <snalwuer@cip.informatik.uni-erlangen.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:55335 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbXFYXxC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jun 2007 19:53:02 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1095699wra
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jun 2007 16:53:01 -0700 (PDT)
In-Reply-To: <20070624225809.GI9741@cip.informatik.uni-erlangen.de>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6/25/07, Alexander Wuerstlein
<snalwuer@cip.informatik.uni-erlangen.de> wrote:
> On 070622 21:40, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > [...]
> > But first: Have you checked the digsig project? It's been doing
> > (for some time) what your current patchset proposes -- and
> > it uses public key cryptosystems for the key management,
> > which is decidedly better than using secret-keyed hashes
> > (HMAC, XCBC). Also, digsig aims to protect executable
> > binaries in general, and not just suid / sgid ones.
>
> We have not heard about digsig before, thanks for pointing it out. After a
> short look over the source (correct me if I'm wrong): The most important
> difference between our project and digsig is that digsig relies on storing
> signatures inside the ELF file structure. Therefore a handmade binary-loader or
> just COFF binaries could be used to circumvent digsig.

Yes, that's correct.

> We decided against
> altering the file itself for that and some other reasons.
> The limitation to suid/sgid was only due to a limited amount of time we had for
> implementing our patch. For the future we are planning further uses like
> setting capabilities only for signed binaries.

Ok, effectively what you have there is a signature on an entire file stored in
one of its extended attributes, so I suspect you could think of few other
applications for something like this too.

> > Second: Can we have some discussion on the security model /
> > threat model / trust model / cryptographic key management
> > scheme of your signing mechanism? [I had read through the
> > [0/4] mail you had sent yesterday, but found no relevant
> > discussion on these aspects there.]
> [...]
> An admin would verify the to-be-installed binaries (e.g. by reading the source,
> checking the distribution's package signatures), sign them in a central
> location.  He then distributes those signatures along with the installation
> packages onto his computers. There should only be one key in use at a site the
> public part of which is compiled into the kernel. Any kind of chain-of-trust
> should be handled in userspace by signing or not signing with the site-wide
> key depending on the earlier signatures in the chain.

Ok, so:

1. Admin is trusted. [ This need not mean the same as: "superuser
_account_ is trusted", but let's stay in the real world in for now. ]
2. Signing happens at some central, assumed-to-be-secure location (and say
the private key never leaves that central secure location). And let's say the
admin *repackages* the packages, this time such that the signed files get the
signature-carrying-extended-attributes with them, so the installation
automatically copies them correctly. => nothing wrong with this assumption.
3. Kernel verifies signatures at runtime. => kernel is trusted.
4. Public key needs to be *compiled into* the kernel ... so this is not getting
into mainline, but fair enough as something site administrators would patch in
and build.
5. Chain-of-trust handled in userspace. => userspace is trusted.

Let me know if I got the trust model / key management wrong.

> So far for the initial idea. Perhaps it would be useful to have more than one
> key or some more complex scheme for obtaining the keys and checking their
> validity.  But as all of this would need to be part of the kernel we decided to
> rather keep it as simple as possible, anything complex is better and more
> flexibly done in userspace.

Well, if you're trusting (privileged) userspace already, I'm suddenly
not so sure
as to what new is this patchset bringing to the table in the first
place ... could
you also describe the attack vectors / threats that you had in mind that get
blocked with the proposed scheme?

> > From the patchset, it appears you use a *common* secret key
> > for _all_ signed binaries, and it is set at kernel build-time itself:
> > [...]
> > Anyway, this is *totally* insecure and broken. Do you realize anybody
> > who lays hands on the kernel image can now _trivially_ extract the
> > should-have-been-a-secret key from it and use it to sign his own
> > binaries?
>
> We do realize that this is really really ugly, broken and nasty and nobody
> would or should ever want to use it for anything but playing around as it is
> atm. ;)
>
> We only used HMAC because it was already available inside the kernel, for
> implementing real asymetric cryptography there was simply no time. Of course
> our next objective is to implement that.

Have a look at modsign (signed kernel modules) project too (just the key
management part, specifically the asymmetric crypto and DSA implementation
that they've already ported to the kernel). You could also go through the lkml
archives for whenever that was proposed for inclusion in mainline ...

Satyam
