Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41575 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbeLJXM3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 18:12:29 -0500
Date: Mon, 10 Dec 2018 15:12:00 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "open list:INTEL SGX" <intel-sgx-kernel-dev@lists.01.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)"
        <kvm@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SPARSE CHECKER" <linux-sparse@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
Message-ID: <20181210231159.GA10718@localhost>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
 <20180612105011.GA26931@amd>
 <20180619145943.GC8034@linux.intel.com>
 <20180619200414.GA3143@amd>
 <20180619214833.GA5873@localhost>
 <20181209200600.GA11608@amd>
 <20181210074717.GA9880@localhost>
 <20181210082704.GA14594@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210082704.GA14594@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 10, 2018 at 09:27:04AM +0100, Pavel Machek wrote:
> On Sun 2018-12-09 23:47:17, Josh Triplett wrote:
> > On Sun, Dec 09, 2018 at 09:06:00PM +0100, Pavel Machek wrote:
> > ...
> > > > > > The default permissions for the device are 600.
> > > > > 
> > > > > Good. This does not belong to non-root.
> > > > 
> > > > There are entirely legitimate use cases for using this as an
> > > > unprivileged user. However, that'll be up to system and distribution
> > > > policy, which can evolve over time, and it makes sense for the *initial*
> > > > kernel permission to start out root-only and then adjust permissions via
> > > > udev.
> > > 
> > > Agreed.
> > > 
> > > > Building a software certificate store. Hardening key-agent software like
> > > > ssh-agent or gpg-agent. Building a challenge-response authentication
> > > > system. Providing more assurance that your server infrastructure is
> > > > uncompromised. Offloading computation to a system without having to
> > > > fully trust that system.
> > > 
> > > I think you can do the crypto stuff... as crypto already verifies the
> > > results. But I don't think you can do the computation offload.
> > 
> > You can, as long as you can do attestation.
> 
> You can not, because random errors are very easy to trigger for person
> with physical access,

Random errors can also just happen, so if you're concerned about that
you might want to build each object on two different machines and
compare. Good luck generating the *same* random errors on two machines.

(And, of course, someone can also DoS you in any number of other ways,
such as accepting data and then never sending back a result. So you'll
need timeouts and failovers.)

> > > > As one of many possibilities, imagine a distcc that didn't have to trust
> > > > the compile nodes. The compile nodes could fail to return results at
> > > > all, but they couldn't alter the results.
> > > 
> > > distcc on untrusted nodes ... oh yes, that would be great.
> > > 
> > > Except that you can't do it, right? :-).
> > > 
> > > First, AFAICT it would be quite hard to get gcc to run under SGX. But
> > > maybe you have spare month or three and can do it.
> > 
> > Assuming you don't need to #include files, gcc seems quite simple to run
> > in an enclave: data in, computation inside, data out.
> 
> So is there a plan to run dynamically linked binaries inside enclave?

I've seen some approaches for that, but you could also just statically
link your compiler. (Since you'd need attestation for all the individual
libraries, you'd need to know the versions of all those libraries, so
you might as well just statically link.)

> Or maybe even python/shell scripts? It looked to me like virtual
> memory will be "interesting" for enclaves.

Memory management doesn't seem that hard to deal with.
