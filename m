From: "Yang Shi" <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Subject: Re: [PATCH 7/8] net: ovs: remove unused hardirq.h
Date: Fri, 08 Dec 2017 03:14:58 +0800
Message-ID: <a9213170-3cc2-8267-d1f5-53078db7fdb2@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
	<1510959741-31109-7-git-send-email-yang.s@alibaba-inc.com>
	<7877c3bd-74ec-a7d2-61d3-85a4c452e710@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <7877c3bd-74ec-a7d2-61d3-85a4c452e710-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi folks,

Any comment on this one?

Thanks,
Yang


On 11/17/17 5:48 PM, Yang Shi wrote:
> It looks the email address of Pravin in MAINTAINERS file is obsolete, 
> sent to the right address.
> 
> Yang
> 
> 
> On 11/17/17 3:02 PM, Yang Shi wrote:
>> Preempt counter APIs have been split out, currently, hardirq.h just
>> includes irq_enter/exit APIs which are not used by openvswitch at all.
>>
>> So, remove the unused hardirq.h.
>>
>> Signed-off-by: Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
>> Cc: Pravin Shelar <pshelar-l0M0P4e3n4LQT0dZR+AlfA@public.gmane.org>
>> Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
>> Cc: dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
>> ---
>>   net/openvswitch/vport-internal_dev.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/net/openvswitch/vport-internal_dev.c 
>> b/net/openvswitch/vport-internal_dev.c
>> index 04a3128..2f47c65 100644
>> --- a/net/openvswitch/vport-internal_dev.c
>> +++ b/net/openvswitch/vport-internal_dev.c
>> @@ -16,7 +16,6 @@
>>    * 02110-1301, USA
>>    */
>> -#include <linux/hardirq.h>
>>   #include <linux/if_vlan.h>
>>   #include <linux/kernel.h>
>>   #include <linux/netdevice.h>
>>
