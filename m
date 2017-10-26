From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 0/4] Rearrange functions to remove forward declarations
Date: Thu, 26 Oct 2017 22:33:40 +0530
Message-ID: <CANc+2y4OPz9wPwB7Rj6FgkC=esPyT8VG8-Q8U-toErHrYMxOkA@mail.gmail.com>
References: <20171026153427.22334-1-prasannatsmkumar@gmail.com> <823fc44a-8ccc-1f8d-51f5-a4411362ffbc@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        david.daney@cavium.com, Corentin LABBE <clabbe.montjoie@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
To: David Daney <ddaney@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:48609 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932137AbdJZRDl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 13:03:41 -0400
Received: by mail-io0-f194.google.com with SMTP id j17so6887618iod.5
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 10:03:40 -0700 (PDT)
In-Reply-To: <823fc44a-8ccc-1f8d-51f5-a4411362ffbc@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

On 26 October 2017 at 22:18, David Daney <ddaney@caviumnetworks.com> wrote:
> On 10/26/2017 08:34 AM, PrasannaKumar Muralidharan wrote:
>>
>> This patch series rearranges functions such that forward declarations
>> becomes unnecessary. Remove those forward declaration.
>
>
> Why?
>
> The code churn and increase in difficulty of attribution are big drawbacks
> to this sort of patch set.

Completely agreed. I did understand there is little value in this
change. Wasn't sure whether such a patch is encouraged so gave a try.
I am fine with not taking the patch.

Regards,
PrasannaKumar
