From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH v3 1/3] crypto: qce: Qualcomm crypto engine driver
Date: Tue, 10 Jun 2014 11:34:22 +0300
Message-ID: <5396C30E.8090906@mm-sol.com>
References: <1402315720-5042-1-git-send-email-svarbanov@mm-sol.com>  <1402315720-5042-2-git-send-email-svarbanov@mm-sol.com> <1402332409.3142.2.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Grant Likely <grant.likely@linaro.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1402332409.3142.2.camel@joe-AO725>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Joe,

On 06/09/2014 07:46 PM, Joe Perches wrote:
> On Mon, 2014-06-09 at 15:08 +0300, Stanimir Varbanov wrote:
>> The driver is separated by functional parts. The core part
>> implements a platform driver probe and remove callbaks.
>> The probe enables clocks, checks crypto version, initialize
>> and request dma channels, create done tasklet and init
>> crypto queue and finally register the algorithms into crypto
>> core subsystem.
> 
> trivia:
> 
>> diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
> []
>> +#define AUTH_NONCE_NUM_WORDS_SHIFT	20
>> +#define AUTH_NONCE_NUM_WORDS_MASK	GENMASK(22, 20);
> 
> Unnecessary semicolon and appears to be unused.

Will correct, thanks.

It is unused because I dropped out AEAD support from this set. I plan to
add AEAD incrementally later on.

-- 
regards,
Stan
