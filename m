From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] crypto/nx: Rename nx842_powernv_function as icswx
 function
Date: Tue, 04 Apr 2017 20:32:05 -0700
Message-ID: <58E46535.5080108@linux.vnet.ibm.com>
References: <1491065941.29552.26.camel@hbabu-laptop> <87inmkv348.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, ddstreet@ieee.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        benh@kernel.crashing.org, mikey@neuling.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59877 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752348AbdDEDcU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2017 23:32:20 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v353T8k0004138
        for <linux-crypto@vger.kernel.org>; Tue, 4 Apr 2017 23:32:19 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29mbv3amnk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 04 Apr 2017 23:32:19 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Tue, 4 Apr 2017 21:32:18 -0600
In-Reply-To: <87inmkv348.fsf@concordia.ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/04/2017 04:11 AM, Michael Ellerman wrote:
> Haren Myneni <haren@linux.vnet.ibm.com> writes:
> 
>> [PATCH 1/5] crypto/nx: Rename nx842_powernv_function as icswx function
>>
>> nx842_powernv_function is points to nx842_icswx_function and
>> will be point to VAS function which will be added later for
>> P9 NX support.
> 
> I know it's nit-picking but can you give it a better name while you're
> there.
> 
> I was thinking it should be called "send" or something, but it actually
> synchronously sends and waits for a request.
> 
> So perhaps just nx842_exec(), for "execute a request", and then you can
> have nx842_exec_icswx() and nx842_exec_vas().
> 
> cheers
> 

Michael, 

Thanks for review,

nx842_powernv_function() was used before, So just renamed similar to this name. But I will make changes in the next version.

Haren 
