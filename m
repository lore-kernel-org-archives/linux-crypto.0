From: Timur Tabi <timur@kernel.org>
Subject: Re: [PATCH v5 6/6] crypto: qcom: Add ACPI support
Date: Tue, 10 Jul 2018 18:37:37 -0500
Message-ID: <6d29f5e3-e147-780a-fe49-5420b3934f1c@kernel.org>
References: <20180709061925.20276-1-vkoul@kernel.org>
 <20180709061925.20276-7-vkoul@kernel.org>
 <2a678412-26d4-769e-ff6f-ace5d53e70b5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>
To: Jeffrey Hugo <jhugo@codeaurora.org>, Vinod Koul <vkoul@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2a678412-26d4-769e-ff6f-ace5d53e70b5@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/10/18 12:27 PM, Jeffrey Hugo wrote:
>>
>> Add support for probing on ACPI systems, with ACPI HID QCOM8160.
>>
>> On ACPI systems, clocks are always enabled, the PRNG should
>> already be enabled, and the register region is read-only.
>> The driver only verifies that the hardware is already
>> enabled never tries to disable or configure it.
>>
>> Signed-off-by: Timur Tabi <timur@codeaurora.org>
>> [port to crypto API]
>> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> 
> Tested-by: Jeffrey Hugo <jhugo@codeaurora.org>

Thanks, Jeff.  I appreciate it.
