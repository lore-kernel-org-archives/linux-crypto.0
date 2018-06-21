From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Thu, 21 Jun 2018 12:56:34 +0300
Message-ID: <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Vinod Koul <vinod.koul@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 06/19/2018 05:28 PM, Herbert Xu wrote:
> On Mon, Jun 18, 2018 at 07:42:59PM +0530, Vinod Koul wrote:
>> Qcom 8996 and later chips support prng v2 where we need to only
>> implement .read callback for hwrng.
>>
>> Add a new table for v2 which supports this and get version required for
>> driver data.
>>
>> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> 
> Is this really a pseudo-RNG? If so it needs to be moved over to
> the algif_rng interface.

Despite the register name (PRNG_ registers prefix) the IP is using FIPS
approved algorithm and we can claim that this is true hardware entropy
generator.

I don't think that we need to move to algif_rng.

-- 
regards,
Stan
