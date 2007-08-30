From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Wed, 29 Aug 2007 18:07:54 -0600
Message-ID: <20070830000754.GD5851@cosmic.amd.com>
References: <20070829162200.GE24782@Chamillionaire.breakpoint.cc>
 <E1IQXNV-0003Ed-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@ml.breakpoint.cc, silencer@gmx.ch,
	linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:16822 "EHLO
	outbound8-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbXH3AHO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 20:07:14 -0400
In-Reply-To: <E1IQXNV-0003Ed-00@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 30/08/07 07:55 +0800, Herbert Xu wrote:
> Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
> > 
> > Actually it is. geode does not support keys != 128 bit. ESSIV uses as
> > key the output of sha256 what is 256. Check dmesg please. If my theory
> > is correct than you should see in dmesg or somewhere:
> > "Failed to set key for ESSIV cipher"
> > Is it?
> 
> Jordan, could you please confirm whether geode-aes supports
> key sizes other than 128, i.e., 192 and 256?

No  - just 128.  Bad planning, I guess... :)

JOrdan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.
