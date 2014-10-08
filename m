From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] crypto, qat, use generic numa functions
Date: Wed, 08 Oct 2014 11:59:30 -0400
Message-ID: <54355F62.5050406@redhat.com>
References: <1412727129-14467-1-git-send-email-prarit@redhat.com> <54355D56.8040908@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bruce Allan <bruce.w.allan@intel.com>,
	John Griffin <john.griffin@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbaJHP7i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 11:59:38 -0400
In-Reply-To: <54355D56.8040908@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/08/2014 11:50 AM, Tadeusz Struk wrote:
> Hi Prarit,
> On 10/07/2014 05:12 PM, Prarit Bhargava wrote:
>> The method in which the qat code determines the numa node for memory
>> allocations is a bit clunky.  On 2 socket, single node systems it is
>> possible that adf_get_dev_node_id() returns node 1, even though node 1
>> doesn't exist.
>>
>> This code transitions the qat code to the generic numa functions.
>> Changing adf_get_dev_node_id() to a simple call to dev_get_node() results
>> in a change to the adf_accel_dev struct as well.
> 
> The problem with that is we don't want to use any valid numa node, but
> the node we are connected to or we don't want to use the accelerator at
> all. Otherwise, when the first valid numa node happens to be the remote
> node the dma transactions we be slow and instead of accelerating we will
> slow things down.
> A patch that enforces this is on it's way.

Yeah, I was actually wondering if

dev_get_node() returns NO_NODE, then we should just default to 0?

I'll wait for your patch ...

P.
> 
