From: Jeffrey Hugo <jhugo@codeaurora.org>
Subject: Re: [PATCH v4 6/6] crypto: qcom: Add ACPI support
Date: Mon, 9 Jul 2018 08:52:21 -0600
Message-ID: <e031959c-80cb-575b-8b6a-fc3b2119733b@codeaurora.org>
References: <20180704114427.29953-1-vkoul@kernel.org>
 <20180704114427.29953-7-vkoul@kernel.org>
 <b06a0327-bbfe-5f7c-c0e1-43227ce089ae@kernel.org>
 <20180705060733.GH22377@vkoul-mobl>
 <38f34817-ff86-06b7-4aab-a009c353a6db@kernel.org>
 <20180709060157.GZ22377@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>
To: Vinod <vkoul@kernel.org>, Timur Tabi <timur@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709060157.GZ22377@vkoul-mobl>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/9/2018 12:01 AM, Vinod wrote:
> On 07-07-18, 13:05, Timur Tabi wrote:
>> On 7/5/18 1:07 AM, Vinod wrote:
>>> Yes we can add driver data in ACPI ID as well so code can be:
>>>
>>>           if (!has_acpi_companion(&pdev->dev)) {
>>>                   rng->clk = devm_clk_get(&pdev->dev, "core");
>>>                   if (IS_ERR(rng->clk))
>>>                           return PTR_ERR(rng->clk);
>>>           }
>>>           rng->skip_init = device_get_match_data(&pdev->dev);
>>>
>>> Looks much neater.
>>
>> Yeah, I like it.
>>
>>> I will wait for feedback on other patches before updating this.
>>
>> Jeff said it works, so I guess v5 will be good to go.
> 
> Yes posting that right now. It would be great if you folks can test
> again on ACPI systems
> 
> Thanks
> 
I might need a day, but I'll get to it.

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
