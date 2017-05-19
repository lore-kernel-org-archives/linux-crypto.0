From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 00/30] Standardize doc formats - part 2
Date: Thu, 18 May 2017 22:23:52 -0300
Message-ID: <cover.1495156975.git.mchehab@s-opensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <peterz@infradead.org>,
	"Richard Russon \(FlatCap\)" <ldm@flatcap.org>,
	Jaroslav Kysela <perex@perex.cz>, linux-mtd@lists.infradead.org,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>,
	openipmi-developer@lists.sourceforge.net,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Jonathan Corbet <corbet@lwn.net>, Richard Weinberger <richard@nod.at>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Marek Vasut <marek.vasut@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Darren Hart <dvhart@infradead.org>, linux-crypto@vger.kernel.org,
	Corey Minyard <minyard@acm.org>, Marc Zyngier <marc.zyngier@arm.com>,
	William Breathitt Gray <vilhelm.gray@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>,
	Thoma
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Return-path: <openipmi-developer-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/openipmi-developer>,
	<mailto:openipmi-developer-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=openipmi-developer>
List-Post: <mailto:openipmi-developer@lists.sourceforge.net>
List-Help: <mailto:openipmi-developer-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/openipmi-developer>,
	<mailto:openipmi-developer-request@lists.sourceforge.net?subject=subscribe>
Errors-To: openipmi-developer-bounces@lists.sourceforge.net
List-Id: linux-crypto.vger.kernel.org

Each document under Documentation/*.txt has its own format.
Some follow markup notations, some don't even have a title!

In order to try to get some order on it, change the document
style to the standard we're adopting after the adoption of
ReStructured Text.

The documents touched on this series now build fine with
Sphinx, if renamed to *.rst extension.

The main goal with this is to teach people by example about
what format is expected on newer documents. It also helps
to add those files to Kernel books.

In order to make things more palatable, I'm spliting the
conversion into three parts.

This is	part 2.

Mauro Carvalho Chehab (30):
  iostats.txt: update it to cover recent Kernels
  IPMI.txt: standardize document format
  IRQ-affinity.txt: standardize document format
  IRQ-domain.txt: standardize document format
  irqflags-tracing.txt: standardize document format
  IRQ.txt: add a markup for its title
  isapnp.txt: promote title level
  isa.txt: standardize document format
  kernel-per-CPU-kthreads.txt: standardize document format
  kobject.txt: standardize document format
  kprobes.txt: standardize document format
  kref.txt: standardize document format
  kselftest.txt: standardize document format
  ldm.txt: standardize document format
  lockup-watchdogs.txt: standardize document format
  lzo.txt: standardize document format
  mailbox.txt: standardize document format
  memory-barriers.txt: standardize document format
  memory-barriers.txt: use literals for variables
  memory-hotplug.txt: standardize document format
  men-chameleon-bus.txt: standardize document format
  nommu-mmap.txt: standardize document format
  nommu-mmap.txt: don't use all upper case on titles
  ntb.txt: standardize document format
  numastat.txt: standardize document format
  padata.txt: standardize document format
  parport-lowlevel.txt: standardize document format
  percpu-rw-semaphore.txt: standardize document format
  phy.txt: standardize document format
  pi-futex.txt: standardize document format

 Documentation/IPMI.txt                    |   76 +-
 Documentation/IRQ-affinity.txt            |   77 +-
 Documentation/IRQ-domain.txt              |   69 +-
 Documentation/IRQ.txt                     |    2 +
 Documentation/iostats.txt                 |   44 +-
 Documentation/irqflags-tracing.txt        |   10 +-
 Documentation/isa.txt                     |   53 +-
 Documentation/isapnp.txt                  |    1 +
 Documentation/kernel-per-CPU-kthreads.txt |  156 +++-
 Documentation/kobject.txt                 |   69 +-
 Documentation/kprobes.txt                 |  450 ++++++----
 Documentation/kref.txt                    |  285 ++++---
 Documentation/kselftest.txt               |   37 +-
 Documentation/ldm.txt                     |   54 +-
 Documentation/lockup-watchdogs.txt        |    3 +-
 Documentation/lzo.txt                     |   27 +-
 Documentation/mailbox.txt                 |  181 ++--
 Documentation/memory-barriers.txt         |  794 +++++++++---------
 Documentation/memory-hotplug.txt          |  357 ++++----
 Documentation/men-chameleon-bus.txt       |  298 +++----
 Documentation/nommu-mmap.txt              |   68 +-
 Documentation/ntb.txt                     |   55 +-
 Documentation/numastat.txt                |    5 +-
 Documentation/padata.txt                  |   27 +-
 Documentation/parport-lowlevel.txt        | 1303 ++++++++++++++++++-----------
 Documentation/percpu-rw-semaphore.txt     |    3 +-
 Documentation/phy.txt                     |  106 ++-
 Documentation/pi-futex.txt                |   15 +-
 28 files changed, 2683 insertions(+), 1942 deletions(-)

-- 
2.9.4



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
