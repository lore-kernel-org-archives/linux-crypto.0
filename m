From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Fri, 22 Jun 2018 11:27:59 +0300
Message-ID: <6782b1c0-ea94-b07c-2fae-3fe3223bb22a@linaro.org>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
 <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au>
 <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
 <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
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
In-Reply-To: <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 06/21/2018 02:53 PM, Herbert Xu wrote:
> On Thu, Jun 21, 2018 at 02:27:10PM +0300, Stanimir Varbanov wrote:
>>
>> OK, I just wanted to say that it is _not_ PRNG and the register names
>> gives us wrong impression.
> 
> So does it generate one bit of output for each bit of hardware-
> generated entropy like /dev/random? Or does it use a hardware-
> generated seed to power a PRNG?

I believe it is the second one. Isn't the second one SP 800-90A?

-- 
regards,
Stan
