From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [RFC 0/7] crypto: caam - add Queue Interface (QI) support
Date: Thu, 16 Mar 2017 14:13:52 +0000
Message-ID: <DB4PR04MB0847AD372AFF9510CDCA3ECD98260@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <1488552733-20806-1-git-send-email-horia.geanta@nxp.com>
 <20170316084249.GB11653@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Claudiu Manoil <claudiu.manoil@nxp.com>,
 Cristian Stoica <cristian.stoica@nxp.com>, Dan Douglass <dan.douglass@nxp.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Vakul Garg <vakul@nxp.com>, Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Scott Wood <oss@buserror.net>,
 Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 3/16/2017 10:43 AM, Herbert Xu wrote:
> On Fri, Mar 03, 2017 at 04:52:06PM +0200, Horia Geant=E3 wrote:
>> The patchset adds support for CAAM Queue Interface (QI), the additional
>> interface (besides job ring) available for submitting jobs to the engine
>> on platforms having DPAA (Datapath Acceleration Architecture).
>>
>> Patches 1-4 are QMan dependencies.
>> I would prefer to take them through the crypto tree,
>> but I am open to suggestions.
>>
>> Patch 5 adds a missing double inclusion guard in desc_constr.h.
>>
>> Patch 6 adds the caam/qi job submission backend.
>>
>> Patch 7 adds algorithms (ablkcipher and authenc) that run on top
>> of caam/qi. For now, their priority is set lower than caam/jr.
> =

> I'm fine with the crypto bits.
> =

Herbert,

Thanks for the review.
Should I submit formally, i.e. without the [RFC] prefix?

Scott, Roy,

Do you have any comments wrt. soc/qman patches or with them going
through the crypto tree?

Thanks,
Horia
