From: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Subject: Re: [WIP] crypto: add support for Orion5X crypto engine
Date: Thu, 11 Jun 2009 13:40:03 +0200
Message-ID: <20090611114003.GA6385@Chamillionaire.breakpoint.cc>
References: <20090507210321.GB27695@Chamillionaire.breakpoint.cc> <20090507213922.GV32548@trinity.fluff.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Nicolas Pitre <nico@cam.org>, linux-crypto@vger.kernel.org
To: Ben Dooks <ben-linux@fluff.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55114 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbZFKLkR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 07:40:17 -0400
Content-Disposition: inline
In-Reply-To: <20090507213922.GV32548@trinity.fluff.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Ben Dooks | 2009-05-07 22:39:22 [+0100]:

Sorry for the late reply.

>> diff --git a/drivers/crypto/mv_crypto.c b/drivers/crypto/mv_crypto.c
>> new file mode 100644
>> index 0000000..40eb083
>> --- /dev/null
>> +++ b/drivers/crypto/mv_crypto.c

>> +struct req_progress {
>> +	struct sg_mapping_iter src_sg_it;
>> +	struct sg_mapping_iter dst_sg_it;
>> +
>> +	/* src mostly */
>> +	int this_sg_b_left;
>> +	int src_start;
>> +	int crypt_len;
>> +	/* dst mostly */
>> +	int this_dst_sg_b_left;
>> +	int dst_start;
>> +	int total_req_bytes;
>> +};
>
>kerneldoc style documentation wouldn't go amiss here.
added

>> +
>> +static void reg_write(void __iomem *mem, u32 val)
>> +{
>> +	__raw_writel(val, mem);
>> +}
>> +
>> +static u32 reg_read(void __iomem *mem)
>> +{
>> +	return __raw_readl(mem);
>> +}
>
>do you really need to wrapper these? 
Not really. Initially I planned to pass the device handle instead of the
memory pointer. Also using (addr, val) looks better than the other way
around.

>it is also readl/writel for pointers obtained from ioremap()
correct. So I get rid of my wrapper and switch to readl/writel

>> +
>> +#if 0
>> +static void hex_dump(unsigned char *info, unsigned char *buf, unsigned int len)
>> +{
>> +	printk(KERN_ERR "%s\n", info);
>> +	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET,
>> +			16, 1,
>> +			buf, len, false);
>> +	printk(KERN_CONT "\n");
>> +}
>> +#endif
>
>#if 0 considered bad.
I needed this a few times. Now I don't and its gone.

>> +
>> +static int m_probe(struct platform_device *pdev)
>> +{
>> +	struct crypto_priv *cp;
>> +	struct resource *res;
>> +	int irq;
>> +	int ret;
>> +
>> +	if (cpg) {
>> +		printk(KERN_ERR "Second crypto dev?\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
>> +	if (!res)
>> +		return -ENODEV;
>
>Returning -ENODEV is considered harmful, it will not trigger any warning
>from the driver core.
I switched to ENXIO because that fits better (No such device or address)
I thing. However this also doesn't trigger any warning from the core.
What do you suggest?

>
>-- 
>Ben

Thanks for the review Ben.

Sebastian
