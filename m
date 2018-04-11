From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] crypto: DRBG - guard uninstantion by lock
Date: Wed, 11 Apr 2018 14:29:45 +0200
Message-ID: <CACT4Y+bRmYMt3WuVHE7e624KgRUTXQWa36wn-pr_gm2STq80bQ@mail.gmail.com>
References: <001a114467482dbc4b05692df8f9@google.com> <CACT4Y+aKnKT3AwvbEw_khsYUySLDz4mW7dZ6n7O6McbfPTjd8Q@mail.gmail.com>
 <CACT4Y+Y+ydyBAL=j2QOWaBnpY8+Bsr_80d80RXth0SwuY0wMuQ@mail.gmail.com> <2704286.80iLvC0rRL@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2704286.80iLvC0rRL@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 10, 2018 at 5:35 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Dienstag, 10. April 2018, 17:23:46 CEST schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>> Stephan,
>>
>> Do you have any hypothesis as to why this is not detected by KASAN and
>> causes silent corruptions?
>> We generally try to understand such cases and improve KASAN so that it
>> catches such cases more reliably and they do not cause splashes of
>> random crashes on syzbot.
>
> I do not have any hypothesis at this point. I know that you induce some fault.
> As you mentioned the drbg_kcapi_seed function, I was looking through the error
> code paths to see whether some error handlers trip over each other. But all is
> guesswork so far. And I am not even sure whether the bug is in the DRBG code
> base.
>
> Looking into the trace you sent, I see a NULL pointer dereference. At one
> point there is also the drbg_init_hash_kernel that is called. But nowhere I
> see any smoking gun.
>
> Could you please give me a description of the fault you are inducing?

Hi Stephan,

What do you mean by description of the fault?
It's kernel standard FAULT_INJECTION facility, it injects faults
mainly into kmalloc/slab_alloc (also in a bunch of other things, but
in this case this seems to be kmalloc). In the repro you can see that
it's injecting a fault into 8-th malloc in the setsockopt syscall.

I wonder why you can't reproduce it. I can trigger it reliably in a
qemu. Let's try this:
I have upstream kernel on b284d4d5a6785f8cd07eda2646a95782373cd01e.
Here is my config:
https://gist.githubusercontent.com/dvyukov/f843ea09bc5b9439a820c8e809a5501d/raw/ad330e9b6b710f57f63b61590747b48230e5cb61/gistfile1.txt
Here is the compiler:
https://storage.googleapis.com/syzkaller/gcc-8.0.1-20180301.tar.gz
Build as: make -jN CC=that/gcc/bin/gcc
Then I start qemu as:

qemu-system-x86_64 -hda wheezy.img -net
user,host=10.0.2.10,hostfwd=tcp::10022-:22 -net nic -nographic -kernel
arch/x86/boot/bzImage -append "kvm-intel.nested=1
kvm-intel.unrestricted_guest=1 kvm-intel.ept=1
kvm-intel.flexpriority=1 kvm-intel.vpid=1
kvm-intel.emulate_invalid_guest_state=1 kvm-intel.eptad=1
kvm-intel.enable_shadow_vmcs=1 kvm-intel.pml=1
kvm-intel.enable_apicv=1 console=ttyS0 root=/dev/sda
earlyprintk=serial slub_debug=UZ vsyscall=native rodata=n oops=panic
panic_on_warn=1 panic=86400" -enable-kvm -pidfile vm_pid -m 2G -smp 4
-cpu host

You can find the wheezy.img and ssh key for it here:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#crash-does-not-reproduce

Then I compile this program:
https://gist.githubusercontent.com/dvyukov/1dd75d55efd238e7207af1cc38478b3a/raw/403859b56b161a6fbb158e8953fac5bb6e73b1a1/gistfile1.txt
as: gcc prog.c -static -m32

Run in the qemu and within a minute it gives me the crash.
