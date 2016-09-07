From: Iaroslav Gridin <voker57@gmail.com>
Subject: Re: [PATCH] crypto: qce: Initialize core src clock @100Mhz
Date: Wed, 7 Sep 2016 20:25:01 +0300
Message-ID: <20160907172501.pdkl6o6wr5ly5nbm@localhost>
References: <20160903164535.1118-1-voker57@gmail.com>
 <4e509050-6e8e-069c-f00d-eca9a0f3b33d@mm-sol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        andy.gross@linaro.org, david.brown@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4e509050-6e8e-069c-f00d-eca9a0f3b33d@mm-sol.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

 
> > +	ret = clk_set_rate(qce->core_src, 100000000);
> 
> Could you point me from where you got this number? 

I got it from codeaurora qce driver:
https://android.googlesource.com/kernel/msm/+/android-msm-hammerhead-3.4-kk-r1/drivers/crypto/msm/qce50.c#3386
