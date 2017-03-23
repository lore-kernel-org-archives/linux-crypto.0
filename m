From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Thu, 23 Mar 2017 09:03:23 +0100
Message-ID: <602a68ef-c57a-0092-ebe0-161ec602fad6@linux.vnet.ibm.com>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap>
 <CANc+2y5gv2ygSM4HF69XCW7Bb8UUHN+qJKq0os-mOvYknH+SeQ@mail.gmail.com>
 <20170320132858.GA27044@gondor.apana.org.au>
 <1509135.hmo2UhaKWe@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jan Glauber <jan.glauber@de.ibm.com>,
        Harald Freudenberger <freude@de.ibm.com>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751834AbdCWIDc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 04:03:32 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2N7wjGw108463
        for <linux-crypto@vger.kernel.org>; Thu, 23 Mar 2017 04:03:31 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29bxhtxdaq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 23 Mar 2017 04:03:30 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Thu, 23 Mar 2017 08:03:28 -0000
In-Reply-To: <1509135.hmo2UhaKWe@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/20/2017 02:39 PM, Stephan Müller wrote:
> Am Montag, 20. März 2017, 14:28:58 CET schrieb Herbert Xu:
>
> Hi Herbert,
>
>> On Mon, Mar 20, 2017 at 12:19:32PM +0530, PrasannaKumar Muralidharan wrote:
>>> AF_ALG interface for rng does have seeding support. I think hw_random
>>> does not provide seeding support intentionally as I understand that
>>> True RNG need not require seeding (please correct me if I am wrong).
>> Yes.  We should be converting PRNGs in hwrng over to algif_rng.
> IMHO this not only applies to the PRNGs in drivers/crypto (which should simply 
> register with crypto_register_rngs) but also to ~/hacking/sources/linux/arch/
> s390/crypto/prng.c which exports a /dev/prandom file.
>
> For the seeding, it may make sense to follow the example given with crypto/
> drbg.c using the add_random_ready_callback function.
>
> Ciao
> Stephan
>

I'll have a look on it. Currently the s390/crypto/prng seeds itself with
an algorithm based on the jitter of the very fine granular hardware
clock of a s390 machine. There were some thoughts and measurements
by an mathematician which let to this algorithm. However, long-term
the s390 platform will provide some kind of true hardware random number
generator and the idea is to use this for seeding the prng.

regards
Harald Freudenberger
