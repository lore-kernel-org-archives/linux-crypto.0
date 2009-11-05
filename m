From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86, crypto, Generate .byte code for some new	instructions
 via gas macro
Date: Thu, 05 Nov 2009 08:58:47 -0800
Message-ID: <4AF30447.2030705@zytor.com>
References: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com> <20091105142336.GB1910@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:44939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbZKEQ66 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2009 11:58:58 -0500
In-Reply-To: <20091105142336.GB1910@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/05/2009 06:23 AM, Herbert Xu wrote:
> On Thu, Nov 05, 2009 at 02:44:15PM +0800, Huang Ying wrote:
>> It will take some time for binutils (gas) to support some newly added
>> instructions, such as SSE4.1 instructions or the AES-NI instructions
>> found in upcoming Intel CPU.
>>
>> To make the source code can be compiled by old binutils, .byte code is
>> used instead of the assembly instruction. But the readability and
>> flexibility of raw .byte code is not good.
>>
>> This patch solves the issue of raw .byte code via generating it via
>> assembly instruction like gas macro. The syntax is as close as
>> possible to real assembly instruction.
>>
>> Some helper macros such as MODRM is not a full feature
>> implementation. It can be extended when necessary.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> Once Ingo acks this I'll throw it into cryptodev.
> 

I'm not Ingo, but:

Acked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

