From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 1/5] random: fix crng_ready() test
Date: Thu, 17 May 2018 08:01:04 +0200
Message-ID: <84e0c16c-2b48-69e5-4ca4-2ca3bce15dc9@c-s.fr>
References: <20180413013046.404-1-tytso@mit.edu>
 <1699469.KmO53oa8XU@tauon.chronox.de> <20180413125313.GA2633@thunk.org>
 <4393662.RPWnPK42dp@tauon.chronox.de> <20180413170037.GA28721@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413170037.GA28721@thunk.org>
Content-Language: fr
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Le 13/04/2018 à 19:00, Theodore Y. Ts'o a écrit :
> On Fri, Apr 13, 2018 at 03:05:01PM +0200, Stephan Mueller wrote:
>>
>> What I would like to point out that more and more folks change to
>> getrandom(2). As this call will now unblock much later in the boot cycle,
>> these systems see a significant departure from the current system behavior.
>>
>> E.g. an sshd using getrandom(2) would be ready shortly after the boot finishes
>> as of now. Now it can be a matter minutes before it responds. Thus, is such
>> change in the kernel behavior something for stable?
> 
> It will have some change on the kernel behavior, but not as much as
> you might think.  That's because in older kernels, we were *already*
> blocking until crng_init > 2 --- if the getrandom(2) call happened
> while crng_init was in state 0.
> 
> Even before this patch series, we didn't wake up a process blocked on
> crng_init_wait until crng_init state 2 is reached:
> 
> static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
> {
> 	...
> 	if (crng == &primary_crng && crng_init < 2) {
> 		invalidate_batched_entropy();
> 		crng_init = 2;
> 		process_random_ready_list();
> 		wake_up_interruptible(&crng_init_wait);
> 		pr_notice("random: crng init done\n");
> 	}
> }
> 
> This is the reason why there are reports like this: "Boot delayed for
> about 90 seconds until 'random: crng init done'"[1]
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1685794
> 
> 
> So we have the problem already.  There will be more cases of this
> after this patch series is applied, true.  But what we have already is
> an inconsistent state where if you call getrandom(2) while the kernel
> is in crng_init state 0, you will block until crng_init state 2, but
> if you are in crng_init state 1, you will assume the CRNG is fully
> initialized.
> 
> Given the documentation of how getrandom(2) works what its documented
> guarantees are, I think it does justify making its behavior both more
> consistent with itself, and more consistent what the security
> guarantees we have promised people.
> 
> I was a little worried that on VM's this could end up causing things
> to block for a long time, but an experiment on a GCE VM shows that
> isn't a problem:
> 
> [    0.000000] Linux version 4.16.0-rc3-ext4-00009-gf6b302ebca85 (tytso@cwcc) (gcc version 7.3.0 (Debian 7.3.0-15)) #16 SMP Thu Apr 12 16:57:17 EDT 2018
> [    1.282220] random: fast init done
> [    3.987092] random: crng init done
> [    4.376787] EXT4-fs (sda1): re-mounted. Opts: (null)
> 
> There are some desktops where the "crng_init done" report doesn't
> happen until 45-90 seconds into the boot.  I don't think I've seen
> reports where it takes _minutes_ however.  Can you give me some
> examples of such cases?


On a powerpc embedded board which has an mpc8xx processor running at 
133Mhz, I now get the startup done in more than 7 minutes instead of 30 
seconds. This is due to the webserver blocking on read on /dev/random 
until we get 'random: crng init done':

[    0.000000] Linux version 4.17.0-rc4-00415-gd2f75d40072d 
(root@localhost) (gcc version 5.4.0 (GCC)) #203 PREEMPT Wed May 16 
16:32:02 CEST 2018
[    0.295453] random: get_random_u32 called from 
bucket_table_alloc+0x84/0x1bc with crng_init=0
[    1.030472] device: 'random': device_add
[    1.031279] device: 'urandom': device_add
[    1.420069] device: 'hw_random': device_add
[    2.156853] random: fast init done
[  462.007776] random: crng init done

This has become really critical, is there anything that can be done ?

Christophe

> 
> 					- Ted
> 
> P.S.  Of course, in a VM environment, if the host supports virtio-rng,
> the boot delay problem is completely not an issue.  You just have to
> enable virtio-rng in the guest kernel, which I believe is already the
> case for most distro kernels.
> 
> BTW, for KVM, it's fairly simple to set it the host-side support for
> virtio-rng.  Just add to the kvm command-line options:
> 
>      -object rng-random,filename=/dev/urandom,id=rng0 \
> 	-device virtio-rng-pci,rng=rng0
> 
