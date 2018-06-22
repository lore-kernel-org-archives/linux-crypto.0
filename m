From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v2 0/2] hwrng: Add support for qcpm v2 hwrng
Date: Thu, 21 Jun 2018 23:30:26 -0500
Message-ID: <0383ce35-caea-dc0f-21fd-2f44e44ca8ce@codeaurora.org>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <CAOZdJXUgYpLT=xMos4wKxMOTOZb8rV8is48YjGB8_9okZsuvhQ@mail.gmail.com>
 <20180622042747.GH27187@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>
To: Vinod <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622042747.GH27187@vkoul-mobl>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6/21/18 11:27 PM, Vinod wrote:
> I have checked the series.
> 
> I am not sure I follow that this is v2 and you read CONFIG register.
> Apart from that other changes look mostly okay with few nitpicks:)

It seems that there are two registers sets for v2 hardware, one with 
CONFIG and one without.  I just chose to support the one with.

> But there is a bigger concern raised by Herbert on this not being a true
> RNG and thus should be moved to crypto/

I've asked some of the crypto experts in Q to answer that question.

> I have the changes ready for that, I will test them later today and
> share with you, ACPI addition should be easy on that driver

Ok.  Feel free to just merge my ACPI changes into yours.  Technically, 
it's only a couple lines that are really ACPI-specific.

>> I will probably need you to test my patches as my last day at Qualcomm
>> is the 26th.
> Sad to hear that and good luck in your new adventure

Thanks.

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc.  Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
