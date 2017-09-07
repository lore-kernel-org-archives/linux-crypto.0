From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Thu, 7 Sep 2017 18:15:55 -0500
Message-ID: <54fe8467-0fba-d4a8-84d4-ecd62299a53b@amd.com>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
 <20170907142737.g4aot7xatyopdfwp@pd.tnic>
 <9de7139f-676e-e671-13a1-cbc5170cc816@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>, Borislav Petkov <bp@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0066.outbound.protection.outlook.com ([104.47.32.66]:55568
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750836AbdIGXPT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 19:15:19 -0400
In-Reply-To: <9de7139f-676e-e671-13a1-cbc5170cc816@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/07/2017 05:19 PM, Brijesh Singh wrote:
> Hi Boris,
>
> On 09/07/2017 09:27 AM, Borislav Petkov wrote:
>
> ...
>
>>
>> The commit message above reads better to me as the help text than what
>> you have here.
>>
>> Also, in order to make it easier for the user, I think we'll need a
>> CONFIG_AMD_MEM_ENCRYPT_SEV or so and make that depend on CONFIG_KVM_AMD,
>> this above and all the other pieces that are needed. Just so that when
>> the user builds such a kernel, all is enabled and not her having to go
>> look for what else is needed.
>>
>> And then put the sev code behind that config option. Depending on how
>> ugly it gets...
>>
>
> I will add more detail in the help text. I will look into adding some
> depends.
>
> ...
>
>>> +
>>> +void psp_add_device(struct psp_device *psp)
>>
>> That function is needlessly global and should be static, AFAICT.
>>
>> Better yet, it is called only once and its body is trivial so you can
>> completely get rid of it and meld it into the callsite.
>>
>
> Agreed, will do.
>
> .....
>
>>> +
>>> +static struct psp_device *psp_alloc_struct(struct sp_device *sp)
>>
>> "psp_alloc()" is enough I guess.
>>
>
> I was trying to adhere to the existing ccp-dev.c function naming
> conversion.

I would prefer that we not shorten this. The prior incarnation,
ccp_alloc_struct(), has/had been around for a while. And there are a 
number of
similarly named allocation functions in the driver that we like to keep 
sorted.
If anything, it should be more explanatory, IMO.

>
> ....
>
>>
>> static.
>>
>> Please audit all your functions in the psp pile and make them static if
>> not needed outside of their compilation unit.
>>
>
> Will do.
>
>>> +{
>>> +    unsigned int status;
>>> +    irqreturn_t ret = IRQ_HANDLED;
>>> +    struct psp_device *psp = data;
>>
>> Please sort function local variables declaration in a reverse christmas
>> tree order:
>>
>>     <type> longest_variable_name;
>>     <type> shorter_var_name;
>>     <type> even_shorter;
>>     <type> i;
>>
>
> Got it, will do
>
>
>>> +
>>> +    /* read the interrupt status */
>>> +    status = ioread32(psp->io_regs + PSP_P2CMSG_INTSTS);
>>> +
>>> +    /* invoke subdevice interrupt handlers */
>>> +    if (status) {
>>> +        if (psp->sev_irq_handler)
>>> +            ret = psp->sev_irq_handler(irq, psp->sev_irq_data);
>>> +        if (psp->tee_irq_handler)
>>> +            ret = psp->tee_irq_handler(irq, psp->tee_irq_data);
>>> +    }
>>> +
>>> +    /* clear the interrupt status */
>>> +    iowrite32(status, psp->io_regs + PSP_P2CMSG_INTSTS);
>>
>> We're clearing the status by writing the same value back?!? Shouldn't
>> that be:
>>
>>     iowrite32(0, psp->io_regs + PSP_P2CMSG_INTSTS);
>>
>
> Actually the SW should write "1" to clear the bit. To make it clear, I
> can use value 1 and add comment.
>
>
>
>> Below I see
>>
>>     iowrite32(0xffffffff, psp->io_regs + PSP_P2CMSG_INTSTS);
>>
>> which is supposed to clear IRQs. Btw, you can write that:
>>
>>     iowrite32(-1, psp->io_regs + PSP_P2CMSG_INTSTS);
>>
>
> Sure, I will do that
>
> ...
>
> ...
>
>>> +
>>> +    sp_set_psp_master(sp);
>>
>> So this function is called only once and declared somewhere else. You
>> could simply do here:
>>
>>          if (sp->set_psp_master_device)
>>                  sp->set_psp_master_device(sp);
>>
>> and get rid of one more global function.
>
>
> Sure I can do that.
>
> ....
>
>>> +    /* Enable interrupt */
>>> +    dev_dbg(dev, "Enabling interrupts ...\n");
>>> +    iowrite32(7, psp->io_regs + PSP_P2CMSG_INTEN);
>>
>> Uh, a magic "7"! Exciting!
>>
>> I wonder what that means and whether it could be a define with an
>> explanatory name instead. Ditto for the other values...
>>
>
>
> I will try to define some macro instead of hard coded values.
>
> ....
>
>>> +
>>> +int psp_dev_resume(struct sp_device *sp)
>>> +{
>>> +    return 0;
>>> +}
>>> +
>>> +int psp_dev_suspend(struct sp_device *sp, pm_message_t state)
>>> +{
>>> +    return 0;
>>> +}
>>
>> Those last two are completely useless. Delete them pls.
>>
>
> We don't have any PM support, I agree will delete it.
>
> ...
>
>>> +int psp_request_sev_irq(struct psp_device *psp, irq_handler_t handler,
>>> +            void *data)
>>> +{
>>> +    psp->sev_irq_data = data;
>>> +    psp->sev_irq_handler = handler;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +int psp_free_sev_irq(struct psp_device *psp, void *data)
>>> +{
>>> +    if (psp->sev_irq_handler) {
>>> +        psp->sev_irq_data = NULL;
>>> +        psp->sev_irq_handler = NULL;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>
>> Both void. Please do not return values from functions which are simply
>> void functions by design.
>>
>
> thanks, will fix it.
>
> ...
>
>>> +int psp_request_sev_irq(struct psp_device *psp, irq_handler_t handler,
>>> +            void *data);
>>> +int psp_free_sev_irq(struct psp_device *psp, void *data);
>>> +
>>> +int psp_request_tee_irq(struct psp_device *psp, irq_handler_t handler,
>>> +            void *data);
>>
>> Let them stick out.
>
> okay
>
> ...
>
>>
>>> +int psp_free_tee_irq(struct psp_device *psp, void *data);
>>> +
>>> +struct psp_device *psp_get_master_device(void);
>>> +
>>> +extern const struct psp_vdata psp_entry;
>>> +
>>> +#endif /* __PSP_DEV_H */
>>> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
>>
>> So this file is called sp-dev and the other psp-dev. Confusing.
>>
>> And in general, why isn't the whole thing a single psp-dev and you can
>> save yourself all the registering blabla and have a single driver for
>> the whole PSP functionality?
>>
>> Distros will have to enable everything anyway and the whole CCP/PSP code
>> is only a couple of KBs so you can just as well put it all into a single
>> driver. Hm.
>>
>
> PSP provides the interface for communicating with SEV and TEE FWs. I choose
> to add generic PSP interface first then plug the SEV FW support. The TEE
> commands may be totally different from SEV FW commands hence I tried to put
> all the SEV specific changes into one place and adhere to current ccp file
> naming convention.
>
> At high level, AMD-SP (AMD Secure Processor) (i.e CCP driver) will
> provide the
> support for CCP, SEV and TEE FW commands.
>
>
>          +--- CCP
>          |
> AMD-SP --|
>          |            +--- SEV
>          |            |
>          +---- PSP ---*
>                       |
>                       +---- TEE
>
> -Brijesh
