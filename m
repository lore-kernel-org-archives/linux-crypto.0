From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Problem with crypto when initializing TKIP
Date: Mon, 16 Apr 2012 10:51:25 -0500
Message-ID: <4F8C3FFD.6030602@lwfinger.net>
References: <4F8BAE2F.5090200@lwfinger.net> <20120416124839.GA5985@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	driverdevel <devel@driverdev.osuosl.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Jan Simonson <jan@simonson.se>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120416124839.GA5985@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/16/2012 07:48 AM, Herbert Xu wrote:
> On Mon, Apr 16, 2012 at 12:29:19AM -0500, Larry Finger wrote:
>>
>> The value of ok is NOTIFY_OK, which leads to a return of -ENOENT and
>> a failure of the initialization.
>
> NOTIFY_OK means that we have no notifiers installed.  Did you
> compile/load CRYPTO_MANAGER?

Thanks for responding. The CRYPTO_MANAGER is built in, but your suggestion got 
me into the correct area. For some unknown reason, CONFIG_MICHAEL_MIC was 
dropped from my configuration. When I added it, everything works.

I will improve the error message in the driver.

Thanks again,

Larry
