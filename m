From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/4] crypto: [sha] x86 SHA extension optimization of
 SHA1 and SHA256
Date: Thu, 10 Sep 2015 15:56:06 -0700 (PDT)
Message-ID: <20150910.155606.944423642222505007.davem@davemloft.net>
References: <1441924012.4322.0.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, hpa@zytor.com,
	sean.m.gulley@intel.com, mouli_7982@yahoo.com,
	vinodh.gopal@intel.com, james.guilford@intel.com,
	wajdi.k.feghali@intel.com, jussi.kivilinna@iki.fi,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: tim.c.chen@linux.intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:43172 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbbIJW4K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 18:56:10 -0400
In-Reply-To: <1441924012.4322.0.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Thu, 10 Sep 2015 15:26:52 -0700

> 
> The new x86 SHA extensions provide new hardware accelerated instructions
> for computing SHA1 and SHA256 hashes. This patch series provide the
> assembly routines for SHA1 and SHA256 computation using these new
> instructions to the kernel crypto library.  For 4K data blocks, we've
> seen up to 3.6x speedup over existing SSSE3 enhanced routines in the
> kernel crypto library on Broxton platform.
> 
> Refer to SHA extension programming guide in chapter 8.2 of the
> Intel Architecture Instruction Set Extensions Programming reference.
> https://software.intel.com/sites/default/files/managed/07/b7/319433-023.pdf
> 
> Pre-req patches:
> [1] [PATCH] sha: Enable cpuid check for Intel SHA extensions implementations
> http://marc.info/?l=linux-kernel&m=144019424304089&w=2
> [2] [Patch] x86/insn: perf tools: Add new SHA instructions
> http://marc.info/?l=linux-kernel&m=144119645000679&w=2

Series looks fine to me:

Acked-by: David S. Miller <davem@davemloft.net>
