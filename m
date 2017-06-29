From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: wait in atomic context for an i2c crypto device to finish its
 execution
Date: Thu, 29 Jun 2017 19:16:50 +0300
Message-ID: <ff8cad61-bf88-400d-e36a-a19b9397281d@microchip.com>
References: <b55b7170-786b-3c84-483d-db05e163c14a@microchip.com>
 <CAOtvUMf4Zh2BieEyeq3p+-zgeLmiNx6YPcaQ_WRyXgJPB2aW5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:35733 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdF2QQ4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 12:16:56 -0400
In-Reply-To: <CAOtvUMf4Zh2BieEyeq3p+-zgeLmiNx6YPcaQ_WRyXgJPB2aW5w@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 29.06.2017 13:12, Gilad Ben-Yossef wrote:
> Perhaps I missed something but it sounds like a classic case to use a
> work queue:

Makes sense, thanks!
ta
