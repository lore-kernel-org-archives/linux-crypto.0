From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 01/28] crypto: omap-aes: Fix registration of algorithms
Date: Mon, 20 Jun 2016 15:11:54 +0300
Message-ID: <5767DD8A.9010107@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464771389-10640-2-git-send-email-t-kristo@ti.com>
 <20160607104821.GA520@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: tony@atomide.com, lokeshvutla@ti.com, linux-crypto@vger.kernel.org,
 linux-omap@vger.kernel.org, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20160607104821.GA520@gondor.apana.org.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 07/06/16 13:48, Herbert Xu wrote:
> On Wed, Jun 01, 2016 at 11:56:02AM +0300, Tero Kristo wrote:
>> From: Lokesh Vutla <lokeshvutla@ti.com>
>>
>> Algorithms can be registered only once. So skip registration of
>> algorithms if already registered (i.e. in case we have two AES cores
>> in the system.)
>>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>
> Patch applied.  Thanks.
>

Thanks,

Did you check the rest of the series? I only got feedback for this and 
patch #2 on the series, shall I repost the remainder of the series as a 
whole or...?

-Tero
