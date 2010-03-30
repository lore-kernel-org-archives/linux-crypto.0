From: Brandon Philips <brandon@ifup.org>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Tue, 30 Mar 2010 09:50:09 -0700
Message-ID: <20100330165009.GP21087@jenkins.home.ifup.org>
References: <20100320010849.GA30654@gondor.apana.org.au>
 <20100320042103.GB5127@jenkins>
 <20100320042434.GA32294@gondor.apana.org.au>
 <20100319.222325.260105122.davem@davemloft.net>
 <20100320122959.GA1930@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	rusty@rustcorp.com.au, Kay Sievers <kay.sievers@vrfy.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56538 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0C3RRU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Mar 2010 13:17:20 -0400
Received: by pva18 with SMTP id 18so2900794pva.19
        for <linux-crypto@vger.kernel.org>; Tue, 30 Mar 2010 10:17:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20100320122959.GA1930@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20:29 Sat 20 Mar 2010, Herbert Xu wrote:
> On Fri, Mar 19, 2010 at 10:23:25PM -0700, David Miller wrote:
> >
> > I hear what you're saying Herbert, but thinking about this a bit I
> > really think we should make this situation work instead of fail.
> 
> I think the initial report perhaps painted this in a slight
> different fashion than what it really is.  The code that was
> looping in module.c is not trying to load libcrc32c, but rather
> it is trying to get a reference on the already-loaded libcrc32c
> module.

You are correct. Sorry for the confusion.

> AFAICS the only way to make it "work" would be to reload the
> module in question when we can't get a reference on it.  But
> that would entail recursively loading a module during the process
> of loading another module.
> 
> Rusty can chime in on whether this is doable.
> 
> I think I have a good guess as to why this problem is occuring
> for Brandon.  It is probably the result of two near-simultaneous
> modprobes, one issued against libcrc32c and one against bnx2x.
> 
> So if Suse were doing some kind of parallel booting where multiple
> modules may be loaded together then this could occur.

It is actually due to two nearly simultaneous modprobes of bnx2x from
udev since there are two devices:

02:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme II
BCM5709 Gigabit Ethernet [14e4:1639] (rev 01)
02:00.1 Ethernet controller [0200]: Broadcom Corporation NetXtreme II
BCM5709 Gigabit Ethernet [14e4:1639] (rev 01)

Output from my modprobe strace wrappers:

Process 4589 (first to get to libcrc32c)
------------

4589  execve("/sbin/modprobe.bin", ["/sbin/modprobe.bin", "pci:v000014E4d00001639sv00001014"...], [/* 14 vars */]) = 0

...

4589  open("/lib/modules/2.6.32.9-debug/kernel/lib/libcrc32c.ko", O_RDONLY) = 3
4589  stat("/sys/module", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
4589  stat("/sys/module/libcrc32c", 0x7fff3d03bef0) = -1 ENOENT (No such file or directory)
4589  read(3, "\177E", 2)               = 2
4589  lseek(3, 0, SEEK_SET)             = 0
4589  fstat(3, {st_mode=S_IFREG|0644, st_size=90482, ...}) = 0
4589  mmap(NULL, 90482, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f7963d49000
4589  init_module(0x7f7963d49000, 90482, "") = 0
4589  munmap(0x7f7963d49000, 90482)     = 0
4589  close(3)                          = 0
4589  open("/lib/modules/2.6.32.9-debug/kernel/drivers/net/bnx2.ko", O_RDONLY) = 3
4589  stat("/sys/module", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
4589  stat("/sys/module/bnx2", 0x7fff3d03bf90) = -1 ENOENT (No such file or directory)
4589  read(3, "\177E", 2)               = 2
4589  lseek(3, 0, SEEK_SET)             = 0
4589  fstat(3, {st_mode=S_IFREG|0644, st_size=950325, ...}) = 0
4589  mmap(NULL, 950325, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f7963c4c000
4589  init_module(0x7f7963c4c000, 950325, "") = 0

Process 4590 (loses out on libcrc32c and gets stuck)
------------

4590  execve("/sbin/modprobe.bin", ["/sbin/modprobe.bin", "pci:v000014E4d00001639sv00001014"...], [/* 14 vars */]) = 0

....

4590  open("/lib/modules/2.6.32.9-debug/kernel/lib/libcrc32c.ko",O_RDONLY) = 3
4590  stat("/sys/module", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
4590  stat("/sys/module/libcrc32c", 0x7ffff52a0ef0) = -1 ENOENT (No such file or directory)
4590  read(3, "\177E", 2)               = 2
4590  lseek(3, 0, SEEK_SET)             = 0
4590  fstat(3, {st_mode=S_IFREG|0644, st_size=90482, ...}) = 0
4590  mmap(NULL, 90482, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f1397a1b000
4590  init_module(0x7f1397a1b000, 90482, "") = -1 EEXIST (File exists)
4590  close(3)                          = 0
4590  open("/lib/modules/2.6.32.9-debug/kernel/drivers/net/bnx2.ko", O_RDONLY) = 3
4590  stat("/sys/module", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
4590  stat("/sys/module/bnx2", 0x7ffff52a0f90) = -1 ENOENT (No such file or directory)
4590  read(3, "\177E", 2)               = 2
4590  lseek(3, 0, SEEK_SET)             = 0
4590  fstat(3, {st_mode=S_IFREG|0644, st_size=950325, ...}) = 0
4590  mmap(NULL, 950325, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f139791e000
4590  init_module(0x7f139791e000, 950325, "") = -1 ENOENT (No such file or directory)
4590  write(2, "FATAL: Error inserting bnx2 (/li"..., 145) = 145

As you can see 4589 inserts libcrc32c and the other starts inserting
bnx2 after seeing libcrc32c was loaded. Creating our situation. Phew,
took me a bit to see what was really going on :)

Side note: Intially I thought that modprobe was forking for each
module dependency but that was incorrect after looking at the
code. udev is forking off two modprobes almost at the same time for
each bnx2x device alias when udevadm trigger is called during the boot
sequence.

FWIW, I don't think this is a SUSE thing as our udev is pretty lightly
patched.

Cheers,

	Brandon
