From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Thu, 09 Aug 2018 11:03:20 +0200
Message-ID: <1533805400.17217.16.camel@suse.com>
References: <20180723162302.GA4503@sandybridge-desktop>
         <1532590246.7411.3.camel@suse.com> <20180726081404.GG4244@linux-l9pv.suse>
         <20180730170415.GQ4244@linux-l9pv.suse>
         <20180803033702.GB416@sandybridge-desktop>
         <20180803053445.GC4244@linux-l9pv.suse>
         <CADjb_WSURQz86+E8kakNf7UBDM+aho+uaz3QdDkuGsEgan=szw@mail.gmail.com>
         <20180805100200.GB22948@amd> <20180806084534.GB12124@chenyu-desktop>
         <20180808175036.GA16217@amd> <20180809030135.GA21364@chenyu-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ryan Chen <yu.chen.surf@gmail.com>, jlee@suse.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ebiggers@google.com, Theodore Ts'o <tytso@mit.edu>,
        smueller@chronox.de, denkenz@gmail.com,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kookoo.gu@intel.com, Zhang Rui <rui.zhang@intel.com>
To: Yu Chen <yu.c.chen@intel.com>, Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180809030135.GA21364@chenyu-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Do, 2018-08-09 at 11:01 +0800, Yu Chen wrote:

Hi,

> User requirement:
> A is the user, B is the attacker, user A launches a STD and
> encrypts A's ram data, then writes these encrypted data onto
> the disk,  so that: Even if user B has access to the disk,
> B could not know the content of A. Which implies:
> 1. If B unplugs the disk from A's machine, and plugs the disk onto
>    another machine, B could not decode the content without A's
>    'permission'.

That is what encrypted STD does.

> 2. If B is using the same machine as A, even A has walked away leaving
>    the system suspend, B could not resume to A's context without
>    A's 'permission'.

No, that is out of scope for Secure Boot

> Previously, there are three proposal for this:
> a. Enhance the uswsusp(Pavel)
> b. Using user provided password to generate the key, for encryption(Yu)
> c. Using security boot(TPM or EFI key) for encryption(Joey)
> 
> Since I was proposing solution b, I'll say a little more about it.
> The original idea was that, the user provides a password, then this
> password is used to generate the key, which means, if user B has provided
> an incorrect password, the kernel will fail to decrypt the data and is
> likely to fail the resume process. That is to say, no matter
> which physical machine B is using, only if he has provided the
> password, he would be able to resume. In the first version, the key
> deviration was firstly done in kernel space, which satisfies the
> requirement and both saftey. Unfortunately it was rejected and
> people would like to see the key generated in user space instead.
> However, using user provided key directly is not safe, according
> to the discussion in the thread. I don't have good idea on
> how to improve this, but only have some workarounds, say, ask the
> kernel to use TPM key to protects the user provided 'key', etc.

Well, this has no relation to Secure Boot.
Secure Boot will not prevent you from booting the machine.
It restricts the OS you can boot to a cryptographically signed subset.

If you want to demand a password to resume a machine, you can
do so. But it has no relation to encrypted STD, other than that
you need encrypted STD for this to make sense.

> Then let's talk a little more about secure boot. According
> to my understanding, the situation secure boot tries to deal
> with is a little different from the user case we raised above -
> It is an enhancement for case 1, because it refuses to resume
> once the machine is changed. And it does not cover case 2. But
> if it is a requirement from the user, that's ok.
> 
> uswsusp is to do all the staff in user space, and other two
> aim to do all the staff in kernel space. I'm not arguing
> which one is better, but I'm not sure how often user is using
> it, as we don't get uswsusp related bug report on kernel
> bugzilla (both internally)recent years. Another point is,
> why the compression is in kernel rather than in uswsusp,
> it looks like the same case as encryption here.

Secure Boot has no concept of users. Code is trusted, not users.
For Secure Boot to work, you need a key generated and RAM encrypted
in kernel space.

If you want a requirement to restrict booting or resuming, you need
to encrypt the key. These are different things.

	Regards
		Oliver
