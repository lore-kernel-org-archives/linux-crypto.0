From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: n2: make of_device_ids const
Date: Thu, 15 Jun 2017 11:11:11 -0400 (EDT)
Message-ID: <20170615.111111.1375437088749599511.davem@davemloft.net>
References: <9ab9e99928c8add9d11779c5f5a267f10f166875.1497527778.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, tglx@linutronix.de,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: arvind.yadav.cs@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9ab9e99928c8add9d11779c5f5a267f10f166875.1497527778.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Date: Thu, 15 Jun 2017 17:28:10 +0530

> of_device_ids are not supposed to change at runtime. All functions
> working with of_device_ids provided by <linux/of.h> work with const
> of_device_ids. So mark the non-const structs as const.
> 
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>    2001	   2168	     48	   4217	   1079	drivers/crypto/n2_core.o
> 
> File size after constify dummy_tlb_ops.:
>    text	   data	    bss	    dec	    hex	filename
>    3601	    536	     48	   4185	   1059	drivers/crypto/n2_core.o
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
