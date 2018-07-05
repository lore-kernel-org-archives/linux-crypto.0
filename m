From: Jeffrey Hugo <jhugo@codeaurora.org>
Subject: Re: [PATCH v3 6/6] crypto: qcom: Add ACPI support
Date: Thu, 5 Jul 2018 08:26:49 -0600
Message-ID: <6d8ee620-80d5-b529-1256-0624b1fbd98d@codeaurora.org>
References: <20180703060434.19293-1-vkoul@kernel.org>
 <20180703060434.19293-7-vkoul@kernel.org>
 <28000d33-5321-76af-7985-94a564a75336@codeaurora.org>
 <20180704041310.GV22377@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Vinod <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704041310.GV22377@vkoul-mobl>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/3/2018 10:13 PM, Vinod wrote:
> On 03-07-18, 11:08, Jeffrey Hugo wrote:
>> On 7/3/2018 12:04 AM, Vinod Koul wrote:
> 
>>> +#if IS_ENABLED(CONFIG_ACPI)
>>> +static const struct acpi_device_id qcom_rng_acpi_match[] = {
>>> +	{
>>> +		.id = "QCOM8160",
>>> +	},
>>> +	{}
>>> +};
>>> +MODULE_DEVICE_TABLE(acpi, msm_rng_acpi_match);
>>
>> qcom_rng_acpi_match?
>> Looks like a copy/paste issue.  This causes a build failure for me.
>> I'm trying to see if it works otherwise...
> 
> Ah sorry about that, I though I had fixed it, looks like I missed to
> fold the fix.
> 
> Did it work for you?
> 
It seems to work.  Driver compiles, and loads.  Still working on the 
verification.

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
