Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5FF19DF93;
	Mon, 24 Jun 2024 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719246849; cv=none; b=eR1kcVzK/d8tAjOiEXS7WyMF6hJxV6AS1UE+yM3Ufd9MxRx1vS6osxK3pwNsD5WBE7r65d+MCGGyn2sBEfDWTIJIjH+147D0/NWvlcFzG0rIXmwIpD0hTvbSA3ZYQWA2r010YVzD/E5oO75rE79U6AyaOTaEwYrpsN1ClyHmHhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719246849; c=relaxed/simple;
	bh=W3PkXkZ6VAYISV7eN3DcrD8xNc2hicTHsiTcK8+tvRA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W04fBeK2QwlP+SdDvrFJQCGwjGAZNRfIVYOYIZ+sC/di69+ojDPDtZxP7WUnZQFTVAM62Oxx4ksXhOIl0LlfM94CDeUaQcA5jgsqEb+s3a7vFVafOJ++D6XE3kX9+eoe7bZeTxnoFNJmokcO0Rhvm5BjfDlDXePMMjQ0d6UgJnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E8D4DA7;
	Mon, 24 Jun 2024 09:34:31 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD31B3F6A8;
	Mon, 24 Jun 2024 09:34:04 -0700 (PDT)
Date: Mon, 24 Jun 2024 17:34:02 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: kernel test robot <lkp@intel.com>, Chen-Yu Tsai <wens@csie.org>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 Jernej Skrabec <jernej.skrabec@gmail.com>, Samuel Holland
 <samuel@sholland.org>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
 <krzk@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
 devicetree@vger.kernel.org
Subject: Re: [PATCH 2/4] crypto: sun8i-ce - wrap accesses to descriptor
 address fields
Message-ID: <20240624173402.7a327693@donnerap.manchester.arm.com>
In-Reply-To: <202406181436.RZPPffYb-lkp@intel.com>
References: <20240616220719.26641-3-andre.przywara@arm.com>
	<202406181436.RZPPffYb-lkp@intel.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Jun 2024 15:39:21 +0800
kernel test robot <lkp@intel.com> wrote:

Dear bot,

> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on sunxi/sunxi/for-next]
> [also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.10-rc4 next-20240617]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Andre-Przywara/dt-bindings-crypto-sun8i-ce-Add-compatible-for-H616/20240617-061144
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/sunxi/linux.git sunxi/for-next
> patch link:    https://lore.kernel.org/r/20240616220719.26641-3-andre.przywara%40arm.com
> patch subject: [PATCH 2/4] crypto: sun8i-ce - wrap accesses to descriptor address fields
> config: loongarch-randconfig-r111-20240618 (https://download.01.org/0day-ci/archive/20240618/202406181436.RZPPffYb-lkp@intel.com/config)
> compiler: loongarch64-linux-gcc (GCC) 13.2.0
> reproduce: (https://download.01.org/0day-ci/archive/20240618/202406181436.RZPPffYb-lkp@intel.com/reproduce)

For the records: it looks like MIPS (the other report) and Loongson are the
two architectures that the bot built a big endian kernel for, and which
are using the asm-generic writel() implementation.
If I configure the arm64 kernel for big endian, I get this sparse warning
as well.

> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202406181436.RZPPffYb-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:175:34: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] value @@     got restricted __le32 @@  
>    drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:175:34: sparse:     expected unsigned int [usertype] value
>    drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:175:34: sparse:     got restricted __le32
> 
> vim +175 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> 
>    167	
>    168		mutex_lock(&ce->mlock);
>    169	
>    170		v = readl(ce->base + CE_ICR);
>    171		v |= 1 << flow;
>    172		writel(v, ce->base + CE_ICR);
>    173	
>    174		reinit_completion(&ce->chanlist[flow].complete);
>  > 175		writel(sun8i_ce_desc_addr(ce, ce->chanlist[flow].t_phy),  

So this turns out to be a genuine bug. All the other users of this new
sun8i_ce_desc_addr() function write its return value into a DMA
descriptor, which is a data structure that is interpreted by hardware. So
all fields in there must be little endian, and the type of __le32 enforces
this.
However this one caller here passes the value to writel(), which
expects a "natural" u32 and does a cpu_to_le32 conversion internally -
for related, but slightly different reasons.
So on a BE kernel this would have swapped the bytes twice, leading to the
original BE value wrongly written into the register.

So thanks for catching this, sparse and kernel test bot!

Fixed in v2, to be send out ASAP.

Cheers,
Andre

>    176		       ce->base + CE_TDQ);
>    177	
>    178		ce->chanlist[flow].status = 0;
>    179		/* Be sure all data is written before enabling the task */
>    180		wmb();
>    181	
>    182		/* Only H6 needs to write a part of t_common_ctl along with "1", but since it is ignored
>    183		 * on older SoCs, we have no reason to complicate things.
>    184		 */
>    185		v = 1 | ((le32_to_cpu(ce->chanlist[flow].tl->t_common_ctl) & 0x7F) << 8);
>    186		writel(v, ce->base + CE_TLR);
>    187		mutex_unlock(&ce->mlock);
>    188	
>    189		wait_for_completion_interruptible_timeout(&ce->chanlist[flow].complete,
>    190				msecs_to_jiffies(ce->chanlist[flow].timeout));
>    191	
>    192		if (ce->chanlist[flow].status == 0) {
>    193			dev_err(ce->dev, "DMA timeout for %s (tm=%d) on flow %d\n", name,
>    194				ce->chanlist[flow].timeout, flow);
>    195			err = -EFAULT;
>    196		}
>    197		/* No need to lock for this read, the channel is locked so
>    198		 * nothing could modify the error value for this channel
>    199		 */
>    200		v = readl(ce->base + CE_ESR);
>    201		switch (ce->variant->esr) {
>    202		case ESR_H3:
>    203			/* Sadly, the error bit is not per flow */
>    204			if (v) {
>    205				dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
>    206				err = -EFAULT;
>    207				print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
>    208					       cet, sizeof(struct ce_task), false);
>    209			}
>    210			if (v & CE_ERR_ALGO_NOTSUP)
>    211				dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
>    212			if (v & CE_ERR_DATALEN)
>    213				dev_err(ce->dev, "CE ERROR: data length error\n");
>    214			if (v & CE_ERR_KEYSRAM)
>    215				dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
>    216			break;
>    217		case ESR_A64:
>    218		case ESR_D1:
>    219		case ESR_H5:
>    220		case ESR_R40:
>    221			v >>= (flow * 4);
>    222			v &= 0xF;
>    223			if (v) {
>    224				dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
>    225				err = -EFAULT;
>    226				print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
>    227					       cet, sizeof(struct ce_task), false);
>    228			}
>    229			if (v & CE_ERR_ALGO_NOTSUP)
>    230				dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
>    231			if (v & CE_ERR_DATALEN)
>    232				dev_err(ce->dev, "CE ERROR: data length error\n");
>    233			if (v & CE_ERR_KEYSRAM)
>    234				dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
>    235			break;
>    236		case ESR_H6:
>    237			v >>= (flow * 8);
>    238			v &= 0xFF;
>    239			if (v) {
>    240				dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
>    241				err = -EFAULT;
>    242				print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
>    243					       cet, sizeof(struct ce_task), false);
>    244			}
>    245			if (v & CE_ERR_ALGO_NOTSUP)
>    246				dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
>    247			if (v & CE_ERR_DATALEN)
>    248				dev_err(ce->dev, "CE ERROR: data length error\n");
>    249			if (v & CE_ERR_KEYSRAM)
>    250				dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
>    251			if (v & CE_ERR_ADDR_INVALID)
>    252				dev_err(ce->dev, "CE ERROR: address invalid\n");
>    253			if (v & CE_ERR_KEYLADDER)
>    254				dev_err(ce->dev, "CE ERROR: key ladder configuration error\n");
>    255			break;
>    256		}
>    257	
>    258		return err;
>    259	}
>    260	
> 

