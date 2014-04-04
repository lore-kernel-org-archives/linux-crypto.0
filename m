From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH 2/9] crypto: qce: Add register defines
Date: Fri, 04 Apr 2014 10:23:17 +0100
Message-ID: <533E7A05.9060806@linaro.org>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Minor nitpicks.

On 03/04/14 17:17, Stanimir Varbanov wrote:
> +#define REQ_SIZE			17 /* bit 20-17 */

I would have defined macros like this with _SHIFT at the end, something=
=20
like this:

#define REQ_SIZE_SHIFT 		17

> +#define REQ_SIZE_MASK			(0xf << REQ_SIZE)
You could possibly use GENMASK macro for this, its much readable, in=20
*some cases* it could reduce few more lines in header too.

#define REQ_SIZE_MASK		GENMASK(20, 17)


My comments are equally applicable to most macros in this header file.

--
srini
Linaro Qualcomm Landing Team.
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
