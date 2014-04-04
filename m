From: Stanimir Vabanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH 2/9] crypto: qce: Add register defines
Date: Sat, 05 Apr 2014 01:14:04 +0300
Message-ID: <533F2EAC.20501@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com> <533E7A05.9060806@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <533E7A05.9060806@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Srini,

Thanks for the comments.

On 04/04/2014 12:23 PM, Srinivas Kandagatla wrote:
> 
> Minor nitpicks.
> 
> On 03/04/14 17:17, Stanimir Varbanov wrote:
>> +#define REQ_SIZE            17 /* bit 20-17 */
> 
> I would have defined macros like this with _SHIFT at the end, something
> like this:
> 
> #define REQ_SIZE_SHIFT         17

sure, I will add _SHIFT suffix to all places where it is applicable.

> 
>> +#define REQ_SIZE_MASK            (0xf << REQ_SIZE)
> You could possibly use GENMASK macro for this, its much readable, in
> *some cases* it could reduce few more lines in header too.
> 
> #define REQ_SIZE_MASK        GENMASK(20, 17)
> 
> 
> My comments are equally applicable to most macros in this header file.

yes, right will do. Thanks.

regards,
Stan
