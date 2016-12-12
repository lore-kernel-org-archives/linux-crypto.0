From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 2/2] crypto: add virtio-crypto driver
Date: Mon, 12 Dec 2016 18:54:07 +0800
Message-ID: <20161212105407.GA3033@gondor.apana.org.au>
References: <1481171829-116496-1-git-send-email-arei.gonglei@huawei.com>
	<1481171829-116496-3-git-send-email-arei.gonglei@huawei.com>
	<33183CC9F5247A488A2544077AF19020DA15A07C@DGGEMA505-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
	"Huangweidong \(C\)" <weidong.huang@huawei.com>,
	Claudio Fontana <Claudio.Fontana@huawei.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"Hanweidong \(Randy\)" <hanweidong@huawei.com>,
	Luonengjun <luonengjun@huawei.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Wanzongshun \(Vincent\)" <wanzongshun@huawei.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>,
	"Xuquan \(Quan Xu\)" <xuquan8@huawei.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "Zhoujian \(jay,
	Euler\)" <jianjay.zhou@huawei.com>, longpeng <longpeng2@huawei.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"Wubin \(H\)" <wu.wubin@huawei.com>,
	"arei.gonglei@hotmail.co
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <33183CC9F5247A488A2544077AF19020DA15A07C@DGGEMA505-MBX.china.huawei.com>
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

On Mon, Dec 12, 2016 at 06:25:12AM +0000, Gonglei (Arei) wrote:
> Hi, Michael & Herbert
> 
> Because the virtio-crypto device emulation had been in QEMU 2.8,
> would you please merge the virtio-crypto driver for 4.10 if no other
> comments? If so, Miachel pls ack and/or review the patch, then
> Herbert will take it (I asked him last week). Thank you!
> 
> Ps: Note on 4.10 merge window timing from Linus
>  https://lkml.org/lkml/2016/12/7/506
> 
> Dec 23rd is the deadline for 4.10 merge window.

Sorry but it's too late for 4.10.  It needed to have been in my
tree before the merge window opened to make it for this cycle.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
