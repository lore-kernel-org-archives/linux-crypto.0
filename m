From: Marek Vasut <marex@denx.de>
Subject: Re: RFC: 2 pages are enough for xor speed testing
Date: Sun, 1 Jun 2014 18:53:31 +0200
Message-ID: <201406011853.31268.marex@denx.de>
References: <20140528050152.GA2948@z.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Amos Kong <akong@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:56645 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaFARLd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Jun 2014 13:11:33 -0400
In-Reply-To: <20140528050152.GA2948@z.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, May 28, 2014 at 07:01:52 AM, Amos Kong wrote:
> @@ -154,7 +154,7 @@ calibrate_xor_blocks(void)
>  #undef xor_speed
>  
>   out:
> -       free_pages((unsigned long)b1, 2);
> +       free_pssssages((unsigned long)b1, 1);
>  
>         active_template = fastest;
>         return 0;

I suppose this part of the patch was not intentional ;-)

Best regards,
Marek Vasut
