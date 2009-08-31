From: Celejar <celejar@gmail.com>
Subject: Bug#541835: [pkg-cryptsetup-devel] Bug#541835: crypto configuration / dependencies broken
Date: Sun, 30 Aug 2009 20:06:56 -0400
Message-ID: <20090830200656.dbd56f89.celejar@gmail.com>
References: <20090825195852.1dfacb6c.celejar@gmail.com>
	<20090827095516.6817be1e.randy.dunlap@oracle.com>
	<20090827183500.GC24973@resivo.wgnet.de>
	<20090827123401.86cd4319.randy.dunlap@oracle.com>
	<20090828080056.GA3204@Chamillionaire.breakpoint.cc>
	<20090830153722.GA28497@Chamillionaire.breakpoint.cc>
Reply-To: Celejar <celejar@gmail.com>, 541835@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jonas Meurer
 <jonas@freesources.org>, 541835@bugs.debian.org, lkml
 <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@ml.breakpoint.cc>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.541835.B541835.12516772252835@bugs.debian.org>
In-Reply-To: <20090830153722.GA28497@Chamillionaire.breakpoint.cc>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-crypto.vger.kernel.org

On Sun, 30 Aug 2009 17:37:22 +0200
Sebastian Andrzej Siewior <sebastian@ml.breakpoint.cc> wrote:

> * Sebastian Andrzej Siewior | 2009-08-28 10:00:56 [+0200]:
> 
> >>> the problem is not reproducible with a debian/unstable 2.6.30.6 kernel,
> >>> even though it has cbc compiled as module as well. but if I recompile
> >>> the same kernel sources with Celejars kernel .config, the problem
> >>> occurs. thus it must be related to the kernel config in some way.
> >It must be the kernel confing since I run .30.stable and it works. I try
> >to look at it later.
> 
> Your kernel config is fine, the problem is that the initramfs tools do
> not copy all of the required modules into the initramfs. The missing
> modles are:
> - cryptomgr: that one is responsible to load the cbc and aes module and
>   bind them to cbc(aes)
> - chainiv: that one creates IVs if the "user" does not specify one.
>   dm-crypt probably does not use that one but is required due to the way
>   crypto works atm.
> - krng: provides random numbers and is required by chainiv.
> 
> If you add those three to /etc/initramfs/modules than it should work.

Right your are!  It now works, thanks very much.  I guess the catch was
that the working (stock Debian) kernel config built cryptomgr
(CRYPTO_MANAGER and CRYPTO_MANAGER2) and krng (CRYPTO_RNG2, although
not CRYPTO_RNG) and chainiv (CRYPTO_BLKCIPHER2, although not
CRYPTO_BLKCIPHER - I have the impression that chainiv is now
controlled by the BLKCIPHER options?) into the kernel, not as modules,
so I wasn't hit by the initramfs failure until I built them as modules
(I have a bit of a fetish for building everything as a module,
especially when using initrd's :/).

> Could someone please look at initramfs to figure out why those three
> modules are not copied in this reduced setup?

Celejar
-- 
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator
