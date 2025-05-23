Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354911A00FA
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 08:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747988711; cv=none; b=WXcllMLpJ7a1IgBDCQfeG+VyeT7fxIzxUWGVXpkoZU1YG42SaOnF6fJf/7qy1IBmh5aOBPZ71yNbiCTIKMkickq+zh2K92dLSXMXhX5Dz/8rjJ+GP4krwhS1DlHJrH0b3SA5Zw2UUsvZF6ftoekHBSeHhvXxZByTJ3gReeARTtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747988711; c=relaxed/simple;
	bh=+AB/cQQNplXspvGaT86SVBC30Q/dWPdXWy4t9hetblw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PdfoQI8DLPIL+JHfl1tZOmnWKvjc/2PTyNJzTCn6k/tbD+cO4b4TnOgOioSWm4kpGMCF//Ya0BqLUo/YKlxtEyrGkQ0mIeSWQ3LaCTy1/qqrSkaxiG9bIkEi02mV5U0u2w3rxnnHNX20aMJZ8w9guK5Yp2/ZEjBRoxEoI8Ch4oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=PX8cYalt; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="PX8cYalt"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-70de8897628so27074557b3.1
        for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 01:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1747988708; x=1748593508; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozTlr85p37MBd7DohafvC1Zxs26Mw+03vrNjyfwblzs=;
        b=PX8cYaltT+kGwg2+HIYajizv1YCRIICtTgankrsX8kWNvI00ztItqb9r6g85TpLER1
         Ql11syU56gMvFmjgb7FTA8mP+v0iYtOWEhQfb52d8XmSty53B6uzfjyv7xp1Z+PG1ZqV
         xWer2eElCZTyaAkBx8hkqit/fn7ji+iJmt09s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747988708; x=1748593508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ozTlr85p37MBd7DohafvC1Zxs26Mw+03vrNjyfwblzs=;
        b=Im/ySWPMqyqRSOvXBeasBWd2UNFp3gV7T4PavMC6p7ABT/177YSIC7n/Jtzkmg+yZK
         YWtG7s2/DbspTpr8X3v0PgiKV+lerolFJUV9yiFExAE1knCyTusNYat8i7205ASDSLOx
         XumrJSzK5rcWFFVs5bXpanWxyASE9xg2EqSjSR/uxt9ioDgBlojUxyjQZT2OXTkDBjrj
         nD1k5TNU7AuNcchxRSg0GvyZI93mUJBwo4y1HPKmPIlX/NVkbrletMUXAz+kMMEV+VFb
         2uiSnuyAGpWtf1lb6sMzFwTE6z9rfAq5CDHXoepQqyOGcIlG2zv8RQlj2Fqvy8rZsTmB
         IIRQ==
X-Gm-Message-State: AOJu0YxNbSTpFaANUP8v3SACo60/89jsEVQ/A3m2ZX3/xxSVSXJMxtR5
	o/PHE8NfwjMAtHO2wGbq4DXiOMNJSKkY8V9XJxCqpyLgt7t8C9Ke1xdtID2C2TvxDFHnl/wHKqh
	4pnc3t/uSEF2XVAisgC+4ZGZO5ZprNANgS1Zirh8HNg==
X-Gm-Gg: ASbGncuHTlAlXGoGnm/kBhe8P/bBjnrfYILHDX4PYhjfL4YxLDkBirJWeAHldK1R05t
	GhQJGDoVxSELIl5eD32K1/ToRRDZUNTpdsytIL24oZdDKQaHEo4cqE38Y8lxXX83aoHaiBBtfLW
	HEWdQRNTmqKbJkqjQOmAiWr0bH9pZTUVneX7t7LK5sPd2ZMr5q+sAMBw7O9AlptgYrfw==
X-Google-Smtp-Source: AGHT+IFp1nDjBz/k+ErE8pv4fuVNERq7UVPCCdHS62z95kN4AIyxp4riBxQk85up/GM2iKNyckB1WzGH3r45EqsvaQk=
X-Received: by 2002:a05:690c:3389:b0:6f9:a3c6:b2e4 with SMTP id
 00721157ae682-70cab0f8809mr382629937b3.37.1747988708071; Fri, 23 May 2025
 01:25:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
 <20250505125538.2991314-2-pavitrakumarm@vayavyalabs.com> <5b6c66e8-3fac-408f-980c-f261ccd3fefd@kernel.org>
 <bcf5c5de-e649-491b-9849-21eeaae0b64a@kernel.org> <CALxtO0=jB9L4WvaZNjP5qVB1tc9UfhjC5-u7e1dhveaQF=AOEQ@mail.gmail.com>
 <19b1fca7-e1b1-4190-9bcb-7ce36fabd02e@kernel.org> <CALxtO0m_iVo4nnfYg5PzL5K0HgG-U2yNVeS3S0hfdXnObbJDJA@mail.gmail.com>
 <1f4d4292-fbf9-42db-b4e0-6f9326b937fc@kernel.org>
In-Reply-To: <1f4d4292-fbf9-42db-b4e0-6f9326b937fc@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 23 May 2025 13:54:57 +0530
X-Gm-Features: AX0GCFsQo5QAjdkSEaBPBTuoG0Peuu-cIMqDKQYLO4mkJNmy8gGJ-Qbxc3qqJuQ
Message-ID: <CALxtO0kYMXjN5Atp_AZdPp1KuRRJrWh=jThwLCjO3Q1qmFR2wg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: Document support for SPAcc
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	herbert@gondor.apana.org.au, robh@kernel.org, Ruud.Derwig@synopsys.com, 
	Conor Dooley <conor@kernel.org>, davem@davemloft.net, linux-kernel@vger.kernel.org, 
	adityak@vayavyalabs.com, manjunath.hadli@vayavyalabs.com, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,
  My comments are embedded below. Appreciate your inputs.

Warm regards,
PK

On Sun, May 18, 2025 at 7:00=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 13/05/2025 08:30, Pavitrakumar Managutte wrote:
> >>>>>
> >>>>> I do not see any improvements. It seems you ignored all comments, n=
ot
> >>>>> single one was responded to or addressed.
> >>>
> >>> PK: Addressed all the below
> >>>
> >>> 1. SoC Bindings: We dont have any SoC bindings since its tested on th=
e
> >>> Zynq platform (on FPGA). So I have retained just the Synopsys SPAcc
> >>> device here. Also added a detailed description for the same, which
> >>> describes how we have tested the SPAcc peripheral on Zynq. This was
> >>> based on your inputs to describe the existing hardware.
> >>
> >> 1. I asked to use SoC specific compatibles and after such explanation
> >> that you use it in some different, hardware configuration, I asked to
> >> use that.
> >>
> >> Reflect whatever your hardware is called in the compatible.
> >
> > PK: Some context from my side which might clear up things
> > 1. We have developed the SPAcc Crypto Linux driver for the Synopsys SPA=
cc IP.
> > 2. Yes, this is technically a soft IP which we test on FPGA (Zynq
> > Ultrascale Boards).
> > 3. We are NOT evaluating SPAcc IP and thus its not a custom use case
> > or a custom hardware.
> > 4. Also SPAcc IP is NOT part of any SoC yet, but it may be in future.
> >
> > Synopsys Semiconductor IP Business:
> > Synopsys develops Semiconductor IPs (aka DesignWare IPs) and provides
> > Linux device drivers to the SoC Vendors. We, as partners of Synopsys,
> > develop Linux device drivers for the IP, in this case SPAcc. So as of
> > now SPAcc is just a semiconductor IP which is not part of any SoC. A
> > 3rd party SoC vendor would take this and integrate this as part of
> > their upcoming SoC.
> >
> > SPAcc Semiconductor IP details:
> > https://www.synopsys.com/designware-ip/security-ip/security-protocol-ac=
celerators.html
> >
> > Synopsys DesignWare IPs
> > 1. DWC MMC Host controller drivers : drivers/mmc/host/dw_mmc.c
> > 2. DWC HSOTG Driver : drivers/usb/dwc2, drivers/usb/dwc3
> > 3. DWC Ethernet driver : drivers/net/ethernet/synopsys
> > 4. DWC DMA driver : drivers/dma/dw/
> >
> > Intent of upstreaming IP drivers by Synopsys
> > 1. As a Semiconductor IP designer, Synopsys provides Linux device
> > drivers with their IPs to the customers.
> > 2. These Linux drivers handle all the configurations in those respectiv=
e IPs.
> > 3. At this stage of driver development, the focus is on the Semiconduct=
or IP
> > 4. Yes, the IP can be configured differently for different SoCs and
> > the driver has to take care of that.
> > 5. The driver might need some enhancements based on the SoC
> > configurations, which could be done later.
> > 6. Its a good approach to upstream IP drivers, so the vendors could
> > use/enhance the same open sourced drivers.
>
>
> Yeah, I am familiar with this...
>
> >
> >>
> >> I claim this cannot be used in a SoC without customization. If I
> >
> > PK: Synopsys SPAcc is a highly configurable semiconductor IP. I agree
> > that it can be customized for the SoC vendors. But I dont understand
> > why it can't be used without SoC customizations for a default
>
>
> Ask hardware team what is necessary to implement given IP in an SoC. SoC
> architectures are not that simple, that you copy&paste some piece of
> VHDL code and it plugs into existing wiring. You need that wiring, you
> need that SoC specific bits in your design.

PK: I discussed this with my hardware team and their response is as below.

"Besides the bus interface (base address) and interrupt described in
the new binding there are standard power and clock and possibly a
reset interface. However, these have no influence on the driver, so
are not included in the dts to keep things simple.
The hardware IP can be configured to run synchronously to the bus or
have a clock crossing, but as there is no notion of time/frequency in
the driver that's not relevant to the driver.
Same for power signals, there is no additional power management in the IP b=
lock.
If you prefer power/clock/reset to be added, can you please point us
to an example which you consider best practice that we can follow?"

>
> > configuration. All the IP customizations are handled by the driver.
>
> I don't talk about driver. We talk about hardware and bindings.
>
> > Say, in the case of SPAcc, all the IP customizations are accessible as
> > part of the "Version" and "Version Extension-1, 2, 3" registers. So
> > the driver uses these IP customizations and nothing gets hardcoded. In
> > other cases, those customizations will come as vendor specific DT
> > properties.
>
> Do you understand the problem discussed here? There is a long standing
> policy, based on actual real hardware and real cases, that you cannot
> have generic compatibles for custom IP blocks. That's it.
>
PK: Agreed

> >
> > As an IP, which can be memory mapped and with interrupt support, it
> > works perfectly with a default test configuration. And this is what
> > the current driver has.
> >
> >> understood correctly this is soft IP in FPGA for evaluation, so no one
> >> will be ever able to use it. Therefore this binding makes no sense to =
me
> >
> > PK: No, we are not evaluating, but we have developed a driver for
> > SPAcc, which has been tested on a FPGA.
>
> So some sort of FPGA in some sort of setup which you claim with this
> patch is exactly the same for every other SoC. That is the meaning of
> your patch, to which I objected.
PK: Agreed

>
> >
> >> in general: you do not add anything any customer could use. It is fine
> >> to add something which you use internally only, but again describe the
> >> hardware properly.
> >
> > PK: Its not an internal use case. We have tested the SPAcc driver on a
> > FPGA, as detailed above. We dont have any custom hardware and the
> > SPAcc IP is tested in a default configuration.
> >
> > Question : Could you help me understand how a semiconductor IP vendor
> > like Synopsys, upstream Linux drivers for its IPs? In the current
>
> We are not even talking here about drives. I do not have to provide you
> answers for drivers.
>
> I explained already what I expect from bindings: real hardware
> description, so either real SoC or whatever you are having there.

PK: The SPAcc, is also tested on "nsimosci", which is an ARC based
environment. This is our real use case. We already have the ARC dts
files upstreamed as shown below

linux/arch/arc/boot/dts/skeleton.dtsi
linux/arch/arc/boot/dts/skeleton_hs.dtsi
linux/arch/arc/boot/dts/nscimosci.dts
linux/arch/arc/boot/dts/nscimosci_hs.dts

I can add a SPAcc device node to
linux/arch/arc/boot/dts/nscimosci_hs_spacc.dts and accordingly create
the dts yaml bindings. With this change my SPAcc yaml binding is going
to look like the below snippet.

-------------------------------------------------------------
properties:
  compatible:
      - items:
          - const: snps,skeleton_hs-spacc
          - const: snps,dwc-spacc

  reg:
    maxItems: 1

  interrupts:
    maxItems: 1

  clocks:
    maxItems: 1

  ...
  ...

required:
  - compatible
  - reg
  - interrupts

additionalProperties: false

examples:
  - |
    #include <dt-bindings/interrupt-controller/arc-intc.h>

    crypto@40000000 {
        compatible =3D "snps,skeleton_hs-spacc", "snps,dwc-spacc";
        reg =3D <0x40000000 0x3FFFF>;
        interrupt-parent =3D <&core_intc>;
        interrupts =3D <28>;
        clocks =3D <&core_clk>;
        snps,spacc-internal-counter =3D <0x20000>;
        snps,vspacc-id =3D <0>;
   };

-------------------------------------------------------------

>
>
> > scheme of things, if the SoC bindings are mandatory then we dont have
> > them at this stage. Those would have to come from the 3rd party SoC
> > vendors.
> >
> > As a work around, I could add SPAcc bindings to Synopsys's "nsimosci".
> > Please let me know.
> > ARC - linux/arch/arc/boot/dts/nsimosci.dts
> >
> >>
> >> 2. I wrote you entire guide what is wrong with your Cc addresses and
> >> this was fully ignored. Neither responded to, nor resolved.
> >
> > PK: I have fixed that.
>
>
> How? How can you fix a sent v2 with the same issues I pointed out before?
PK: My bad, I will take care of that in V3.
>
>
> Best regards,
> Krzysztof
