From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 0/4] Rearrange functions to remove forward declarations
Date: Thu, 26 Oct 2017 09:48:51 -0700
Message-ID: <823fc44a-8ccc-1f8d-51f5-a4411362ffbc@caviumnetworks.com>
References: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        herbert@gondor.apana.org.au, freude@linux.vnet.ibm.com,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-crypto@vger.kernel.org, mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0062.outbound.protection.outlook.com ([104.47.40.62]:19122
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932127AbdJZQs6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 12:48:58 -0400
In-Reply-To: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/26/2017 08:34 AM, PrasannaKumar Muralidharan wrote:
> This patch series rearranges functions such that forward declarations
> becomes unnecessary. Remove those forward declaration.

Why?

The code churn and increase in difficulty of attribution are big 
drawbacks to this sort of patch set.


> 
> This patch series is boot tested without user space in qemu with
> CONFIG_HW_RANDOM=y.
> 
> PrasannaKumar Muralidharan (4):
>    hw_random: core: Remove forward declaration by rearranging code
>    hw_random: core: Rearranging rng_get_data to remove forward
>      declaration
>    hw_random: core: Rearranging start_khwrngd to remove forward
>      declaration
>    hw_random: core: Remove forward declaration of hwrng_init
> 
>   drivers/char/hw_random/core.c | 151 ++++++++++++++++++++----------------------
>   1 file changed, 72 insertions(+), 79 deletions(-)
> 
