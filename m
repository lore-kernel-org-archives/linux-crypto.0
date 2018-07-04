From: Timur Tabi <timur@kernel.org>
Subject: Re: [PATCH v3 3/6] crypto: Add Qcom prng driver
Date: Wed, 4 Jul 2018 08:42:53 -0500
Message-ID: <181d27ff-e935-ce50-fce2-b114d2d99bc0@kernel.org>
References: <20180703060434.19293-1-vkoul@kernel.org>
 <20180703060434.19293-4-vkoul@kernel.org>
 <2990655.vKmMgW600W@tauon.chronox.de> <20180704041059.GT22377@vkoul-mobl>
 <20180704061035.GY22377@vkoul-mobl>
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
To: Vinod <vkoul@kernel.org>, Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704061035.GY22377@vkoul-mobl>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/4/18 1:10 AM, Vinod wrote:
> Okay so I rechecked this, the hardware gives 32 bits of random data. I
> am thinking of splitting the word and updating by each byte. That way
> trailing zero can also be avoided which is the case now

The current driver only returns data in multiples of 4 bytes.  Why can't 
you keep that?
