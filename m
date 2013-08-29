From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH v2] kernel/padata.c: share code between CPU_ONLINE and
 CPU_DOWN_FAILED, same to CPU_DOWN_PREPARE and CPU_UP_CANCELED
Date: Thu, 29 Aug 2013 13:22:49 +0800
Message-ID: <521EDAA9.5090306@asianux.com>
References: <5212E5E4.8010408@asianux.com> <5212E61F.7010602@asianux.com> <20130822051122.GB26773@secunet.com> <5215A134.90607@asianux.com> <20130822060503.GC26773@secunet.com> <5215B319.3020908@asianux.com> <20130823104448.GI26773@secunet.com> <20130829044259.GB25208@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:63651 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3H2FXy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Aug 2013 01:23:54 -0400
In-Reply-To: <20130829044259.GB25208@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/29/2013 12:42 PM, Herbert Xu wrote:
> On Fri, Aug 23, 2013 at 12:44:48PM +0200, Steffen Klassert wrote:
>> On Thu, Aug 22, 2013 at 02:43:37PM +0800, Chen Gang wrote:
>>> Share code between CPU_ONLINE and CPU_DOWN_FAILED, same to
>>> CPU_DOWN_PREPARE and CPU_UP_CANCELED.
>>>
>>> It will fix 2 bugs:
>>>
>>>   "not check the return value of __padata_remove_cpu() and __padata_add_cpu()".
>>>   "need add 'break' between CPU_UP_CANCELED and CPU_DOWN_FAILED".
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>
>> This looks ok to me, Herbert can you take this one?
>>
>> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> Patch applied.  Thanks!
> 

Thank you too.

-- 
Chen Gang
