From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v6 0/8] Raid: enable talitos xor offload for improving
 performance
Date: Mon, 6 Aug 2012 20:35:06 -0500
Message-ID: <20120806203506.bcf31cc63a2d1f55a9695f13@freescale.com>
References: <1344247815-1104-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: arnd@arndb.de, vinod.koul@intel.com, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, dan.j.williams@gmail.com,
 herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
 dan.j.williams@intel.com, linuxppc-dev@lists.ozlabs.org
To: <qiang.liu@freescale.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1344247815-1104-1-git-send-email-qiang.liu@freescale.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On Mon, 6 Aug 2012 18:10:15 +0800
<qiang.liu@freescale.com> wrote:

> Changes in v6:
> 	- swap the order of original patch 3/6 and 4/6;
> 	- merge Ira's patch to reduce the size of original patch;
> 	- merge Ira's patch of carma in 8/8;
> 	- update documents and descriptions according to Ira's advice;

fwiw, I gave v5 a test-drive, setting up a RAID5 array on ramdisks
[1], and this patchseries, along with FSL_DMA && NET_DMA set seems
to be holding water, so this series gets my:

Tested-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim

[1] mdadm --create --verbose --force /dev/md0 --level=raid5 --raid-devices=4 /dev/ram[0123]
