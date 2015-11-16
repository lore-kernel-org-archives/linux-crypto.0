From: Zain <zain.wang@rock-chips.com>
Subject: Re: [PATCH v3 3/4] Crypto: rockchip/crypto - add crypto driver for
 rk3288
Date: Mon, 16 Nov 2015 09:49:54 +0800
Message-ID: <56493642.9010400@rock-chips.com>
References: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com>
 <2127222.Jhf4CFAOsX@phil> <564586DB.1020401@rock-chips.com>
 <18560338.ihuYOPNcR6@phil>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Heiko Stuebner <heiko@sntech.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.132]:58670 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbKPBud (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Nov 2015 20:50:33 -0500
In-Reply-To: <18560338.ihuYOPNcR6@phil>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2015=E5=B9=B411=E6=9C=8815=E6=97=A5 06:41, Heiko Stuebner wrote:
> Hi Zain,
>
> Am Freitag, 13. November 2015, 14:44:43 schrieb Zain:
>> On 2015=E5=B9=B411=E6=9C=8812=E6=97=A5 20:32, Heiko Stuebner wrote:
>>> Hi Zain,
>>>
>>> I was able to sucessfully test your crypto-driver, but have found s=
ome
>>> improvements below that should probably get looked at:
>>>
>>> Am Mittwoch, 11. November 2015, 14:35:58 schrieb Zain Wang:
>>>> Crypto driver support:
>>>>      ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ed=
e)
>>>> You can alloc tags above in your case.
>>>>
>>>> And other algorithms and platforms will be added later on.
>>>>
>>>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>>>> ---
>>> [...]
>>>
>>>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/cry=
pto/rockchip/rk3288_crypto.c
>>>> new file mode 100644
>>>> index 0000000..bb36baa
>>>> --- /dev/null
>>>> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
>>>> @@ -0,0 +1,392 @@
> [...]
>
> static void rk_crypto_action(void *data)
> {
> 	struct rk_crypto_info *crypto_info =3D data;
>
> 	reset_control_assert(crypto_info->rst);
> }
>
>>>> +static int rk_crypto_probe(struct platform_device *pdev)
>>>> +{
>>>> +	struct resource *res;
>>>> +	struct device *dev =3D &pdev->dev;
>>>> +	struct rk_crypto_info *crypto_info;
>>>> +	int err =3D 0;
>>>> +
>>>> +	crypto_info =3D devm_kzalloc(&pdev->dev,
>>>> +				   sizeof(*crypto_info), GFP_KERNEL);
>>>> +	if (!crypto_info) {
>>>> +		err =3D -ENOMEM;
>>>> +		goto err_crypto;
>>>> +	}
>>>> +
>>>> +	crypto_info->rst =3D devm_reset_control_get(dev, "crypto-rst");
>>>> +	if (IS_ERR(crypto_info->rst)) {
>>>> +		err =3D PTR_ERR(crypto_info->rst);
>>>> +		goto err_crypto;
>>>> +	}
>>>> +
>>>> +	reset_control_assert(crypto_info->rst);
>>>> +	usleep_range(10, 20);
>>>> +	reset_control_deassert(crypto_info->rst);
> 	err =3D devm_add_action(dev, rk_crypto_action, crypto_info);
> 	if (err) {
> 		reset_control_assert(crypto_info->rst);
> 		return err;
> 	}
>
> from here onwards the devm_action will always be executed when either
> _probe fails, or after remove finishes, so no need to assert the rese=
t
> manually.
I have known this function,
rk_crypto_action will be executed next to either failed _probe, or
_remove automatically.
It also make sure reset_control_assert can be executed after tasklet_ki=
ll.

OK! Done!
>
>>>> +
>>>> +	spin_lock_init(&crypto_info->lock);
>>>> +
>>>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +	crypto_info->reg =3D devm_ioremap_resource(&pdev->dev, res);
>>>> +	if (IS_ERR(crypto_info->reg)) {
>>>> +		err =3D PTR_ERR(crypto_info->reg);
>>>> +		goto err_ioremap;
>>>> +	}
>>>> +
>>>> +	crypto_info->aclk =3D devm_clk_get(&pdev->dev, "aclk");
>>>> +	if (IS_ERR(crypto_info->aclk)) {
>>>> +		err =3D PTR_ERR(crypto_info->aclk);
>>>> +		goto err_ioremap;
>>>> +	}
>>>> +
>>>> +	crypto_info->hclk =3D devm_clk_get(&pdev->dev, "hclk");
>>>> +	if (IS_ERR(crypto_info->hclk)) {
>>>> +		err =3D PTR_ERR(crypto_info->hclk);
>>>> +		goto err_ioremap;
>>>> +	}
>>>> +
>>>> +	crypto_info->sclk =3D devm_clk_get(&pdev->dev, "sclk");
>>>> +	if (IS_ERR(crypto_info->sclk)) {
>>>> +		err =3D PTR_ERR(crypto_info->sclk);
>>>> +		goto err_ioremap;
>>>> +	}
>>>> +
>>>> +	crypto_info->dmaclk =3D devm_clk_get(&pdev->dev, "apb_pclk");
>>>> +	if (IS_ERR(crypto_info->dmaclk)) {
>>>> +		err =3D PTR_ERR(crypto_info->dmaclk);
>>>> +		goto err_ioremap;
>>>> +	}
>>>> +
>>>> +	crypto_info->irq =3D platform_get_irq(pdev, 0);
>>>> +	if (crypto_info->irq < 0) {
>>>> +		dev_warn(crypto_info->dev,
>>>> +			 "control Interrupt is not available.\n");
>>>> +		err =3D crypto_info->irq;
>>>> +		goto err_ioremap;
>>>> +	}
>>>> +
>>>> +	err =3D devm_request_irq(&pdev->dev, crypto_info->irq, crypto_ir=
q_handle,
>>>> +			       IRQF_SHARED, "rk-crypto", pdev);
>>> you are freeing the irq manually below and in _remove too. As it st=
ands
>>> with putting the ip block in reset again on remove this should eith=
er loose
>>> the devm_ or you could add a devm_action that handles the reset ass=
ert
>>> like in [0] - registering the devm_action above where the reset is =
done.
>>> That way you could really use dev_request_irq and loose the free_ir=
q
>>> calls here and in remove.
>>>
>>> [0] https://lkml.org/lkml/2015/11/8/159
>> I made a mistake here. I did not remove free_irq when using
>> devm_request_irq.
>>
>> As I do not konw enough about devm_action and reset-assert , can I
>> remove free_irq
>> simply like drivers/i2c/buses/i2c-sun6i-p2wi.c used devm_request_irq=
 and
>> reset_assert?
> I did insert suitable code on how that could look a bit above :-)
Thanks, done!
>
>>> [...]
>>>
>>>> +static int rk_crypto_remove(struct platform_device *pdev)
>>>> +{
>>>> +	struct rk_crypto_info *crypto_tmp =3D platform_get_drvdata(pdev)=
;
>>>> +
>>>> +	rk_crypto_unregister();
>>>> +	reset_control_assert(crypto_tmp->rst);
>>> mainly my comment from above applies, but in any case the reset-ass=
ert
>>> should definitly happen _after_ the tasklet is killed and the irq f=
reed,
>>> to make sure nothing will want to access device-registers anymore.
>>>
>>> [devm works sequentially, so the devm_action would solve that autom=
atically]
>> As I said above, it seem unnecessary to add devm_action.
>>
>> And if modification above is good, I will push tasklet_kill before
>> reset_control_assert in next version.
> I'm unsure ... but I guess if you move the reset-assert after the
> tasklet_kill it might be ok.
I guess I can remove it if I added code you provided above since
reset-assert will be
executed after _remove by rk_crypto_action.
>
>>>> +	tasklet_kill(&crypto_tmp->crypto_tasklet);
>>>> +	free_irq(crypto_tmp->irq, crypto_tmp);
>>>> +
>>>> +	return 0;
>>>> +}
>>> [...]
>>>
>>>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/cry=
pto/rockchip/rk3288_crypto.h
>>>> new file mode 100644
>>>> index 0000000..b5b949a
>>>> --- /dev/null
>>>> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
>>>> @@ -0,0 +1,220 @@
>>>> +#define _SBF(v, f)			((v) << (f))
>>> you are using that macro in this header for simple value shifts lik=
e
>>> 	#define RK_CYYPTO_HASHINSEL_BLOCK_CIPHER_INPUT		_SBF(0x01, 0)
>>>
>>> Removing that macro and doing the shift regularly without any macro=
, like
>>> 	#define RK_CYYPTO_HASHINSEL_BLOCK_CIPHER_INPUT		(0x01 << 0)
>>>
>>>  would improve future readability, because now you need to look up =
what
>>> the macro actually does and the _SBF macro also does not simplify a=
nything.
>>> Also that name is quite generic so may conflict with something else=
 easily.
>> Ok! Done!
>>>  [...]
>>>
>>>> +#define CRYPTO_READ(dev, offset)		  \
>>>> +		readl_relaxed(((dev)->reg + (offset)))
>>>> +#define CRYPTO_WRITE(dev, offset, val)	  \
>>>> +		writel_relaxed((val), ((dev)->reg + (offset)))
>>>> +/* get register virt address */
>>>> +#define CRYPTO_GET_REG_VIRT(dev, offset)   ((dev)->reg + (offset)=
)
>>> same argument as above about readability of the code. What do these
>>> macros improve from just doing the readl and writel calls normally?
>> I am sorry that this macro is define for hash and not be used here.
>> because there are some continuous registers in hash,
>> I think we can use this macro with memcpy like
>>         output =3D CRYPTO_GET_REG_VIRT(dev, RK_CRYPTO_HASH_DOUT_0);
>>         memcpy(dev->ahash_req->result, output,
>> crypto_ahash_digestsize(tfm));
>> instead of multiple readl.
>>
>> I will remove it in next version and add it to hash patch later on.
> I actuall meant all 3 of those macros :-) ... all of them just diguis=
e
> what the code actually does, so don't provide additional value over
> just using readl_relaxed etc directly.
Right.

Thanks
Zain
