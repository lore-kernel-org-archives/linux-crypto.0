From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCHv2 0/6] omap-aes off mode and error handling fixes
Date: Tue, 07 Dec 2010 11:42:24 +0200
Message-ID: <4CFE0180.3030308@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com> <20101202083753.GA23658@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:27509 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0LGJlo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Dec 2010 04:41:44 -0500
In-Reply-To: <20101202083753.GA23658@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

thanks

On 02/12/10 10:37, ext Herbert Xu wrote:
> On Tue, Nov 30, 2010 at 10:13:26AM +0200, Dmitry Kasatkin wrote:
>   
>> Changes to v1:
>> - omap type specific handling removed
>> - fixed backlog handling bug in "redundunt locking is removed"
>> - aes module initialized once per request instead of dma transaction
>>   more efficient and right way to do it
>> - checkpatch fixes in separate patch
>>     
> All applied.  Thanks Dmitry!
>   
