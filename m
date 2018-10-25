Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:62168
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727475AbeJYWia (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Oct 2018 18:38:30 -0400
From: Horia Geanta <horia.geanta@nxp.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roy Pledge <roy.pledge@nxp.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam/qi - simplify CGR allocation, freeing
Date: Thu, 25 Oct 2018 14:05:32 +0000
Message-ID: <VI1PR0402MB3485A342A184BEBB004E74F998F70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20181005125443.dfhd2asqktm22ney@linutronix.de>
 <20181008110937.29198-1-horia.geanta@nxp.com>
 <20181009171101.jk6lgdx4g5rnq7cm@linutronix.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/9/2018 8:11 PM, Sebastian Andrzej Siewior wrote:=0A=
> On 2018-10-08 14:09:37 [+0300], Horia Geant=E3 wrote:=0A=
>> CGRs (Congestion Groups) have to be freed by the same CPU that=0A=
>> initialized them.=0A=
>> This is why currently the driver takes special measures; however, using=
=0A=
>> set_cpus_allowed_ptr() is incorrect - as reported by Sebastian.=0A=
>>=0A=
>> Instead of the generic solution of replacing set_cpus_allowed_ptr() with=
=0A=
>> work_on_cpu_safe(), we use the qman_delete_cgr_safe() QBMan API instead=
=0A=
>> of qman_delete_cgr() - which internally takes care of proper CGR=0A=
>> deletion.=0A=
>>=0A=
>> Link: https://lkml.kernel.org/r/20181005125443.dfhd2asqktm22ney@linutron=
ix.de=0A=
>> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Oh. No more usage of set_cpus_allowed_ptr(). Wonderful. Thank you.=0A=
>  Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>=0A=
> for that.=0A=
> =0A=
> Now that you shifted my attention to qman_delete_cgr_safe().=0A=
> Could you please use work_on_cpu_safe() here instead=0A=
> smp_call_function_single() with preempt_disable() around it?=0A=
> =0A=
> Now, what is the problem with the CPU limitation? Is this a HW=0A=
> limitation that you can access the registers from a certain CPU?=0A=
> =0A=
Roy confirmed the CPU limitation should actually be removed, there is nothi=
ng in=0A=
HW requiring it.=0A=
A clean-up patch will follow.=0A=
=0A=
Thanks,=0A=
Horia=0A=
