From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Thu, 21 Jun 2018 14:27:10 +0300
Message-ID: <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
 <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Vinod Koul <vinod.koul@linaro.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 06/21/2018 01:15 PM, Herbert Xu wrote:
> On Thu, Jun 21, 2018 at 12:56:34PM +0300, Stanimir Varbanov wrote:
>>
>>> Is this really a pseudo-RNG? If so it needs to be moved over to
>>> the algif_rng interface.
>>
>> Despite the register name (PRNG_ registers prefix) the IP is using FIPS
>> approved algorithm and we can claim that this is true hardware entropy
>> generator.
> 
> Whether your RNG is a PRNG or not has nothing to do with the
> algorithm you use.  No algorithm can generate entropy out of thin
> air.

OK, I just wanted to say that it is _not_ PRNG and the register names
gives us wrong impression.

-- 
regards,
Stan
