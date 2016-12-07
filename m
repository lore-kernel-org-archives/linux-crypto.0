From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v5 1/1] crypto: add virtio-crypto driver
Date: Wed, 7 Dec 2016 21:20:39 +0100
Message-ID: <20161207202039.GA27878@ravnborg.org>
References: <1480595945-63656-2-git-send-email-arei.gonglei@huawei.com>
	<201612041032.loAEWLIy%fengguang.wu@intel.com>
	<33183CC9F5247A488A2544077AF19020DA1528DE@DGGEMA505-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Xuquan \(Quan Xu\)" <xuquan8@huawei.com>,
	"Huangweidong \(C\)" <weidong.huang@huawei.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"Wanzongshun \(Vincent\)" <wanzongshun@huawei.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "Zhoujian \(jay,
	Euler\)" <jianjay.zhou@huawei.com>,
	"arei.gonglei@hotmail.com" <arei.gonglei@hotmail.com>,
	"virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
	kbuild test robot <lkp@intel.com>,
	"Hanweidong \(Randy\)" <hanweidong@huawei.com>,
	longpeng <longpeng2@huawei.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Luonengjun <luonengjun@huawei.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Claudio Fontana <Claudio.Fontana@huawei.com>,
	"linux-kernel@vge
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <33183CC9F5247A488A2544077AF19020DA1528DE@DGGEMA505-MBX.china.huawei.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 05, 2016 at 03:12:52AM +0000, Gonglei (Arei) wrote:
> I don't think the root cause of those warnings are introduced by virtio-crypto driver.
> 
> What's your opinion? Sam and David?

Root cause here is that arch/sparc/include/asm/topology_64.h
references cpu_data without including arch/sparc/include/asm/cpudata.h

I think other architectures pull in the dependency from
either smp.h or they have it topology.h.

The easy fix would be to include cpudata.h in arch/sparc/include/asm/topology_64.h.
And that should also be a correct fix.

Could you include this in your patch-set and build test it?

	Sam
