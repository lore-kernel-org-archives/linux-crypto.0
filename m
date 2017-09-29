From: Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Fri, 29 Sep 2017 16:18:16 +0000
Message-ID: <MWHPR12MB160034E91A834504FE85C07BC87E0@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>,
	<fe25071a-18bf-e468-01e7-36515f2110e2@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org" <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
To: "Harsh  Jain" <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>,
	"joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org" <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <fe25071a-18bf-e468-01e7-36515f2110e2-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

| From: Harsh Jain <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
| Sent: Friday, September 29, 2017 1:14:45 AM
|     
| Robin,
| 
| I tried running patch on our test setup.
| 
| With "intel_iommu=on" : I can see single occurrence of DMAR Write failure
| on perf traffic with 10 thread.
| 
| [  749.616480] perf: interrupt took too long (3203 > 3202), lowering kernel.perf_event_max_sample_rate to 62000
| [  852.500671] DMAR: DRHD: handling fault status reg 2
| [  852.506039] DMAR: [DMA Write] Request device [02:00.4] fault addr ef919000 [fault reason 05] PTE Write access is not set
| [root@heptagon linux_t4_build]# cat /proc/cmdline
| BOOT_IMAGE=/vmlinuz-4.9.51+ root=UUID=ccbb7f18-b3f0-43df-89de-07521e9c02fe ro intel_iommu=on crashkernel=auto rhgb quiet rhgb quiet console=ttyS0,115200, console=tty0 LANG=en_US.UTF-8

Harsh. Can you provide the debugging information for that one DMA FAILURE
trace?  It May be yet another corner case in __domain_mapping() or a
different path.

| With intel_iommu=sp_off : It works fine for more than 30 minutes without
| any issues.

I think that even without Robin's patch using intel_iommu=sp_off worked
without errors, right?

Casey
