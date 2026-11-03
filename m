Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723569;
	b=Moh/hMqRzXPOhHmRiu6m5N5dpKDRtkPxIozwNYn8rEaokUxBx+nf2cm3S6kCTrZz0AWy
	 IrJfEkHrtPlEBEvVCRUhRtaCAvrTpVMi561e5Z40VarEThukOc3eb61wAl64ceBSMqDlh
	 dZTglesM1PMLsdzJFHv8fD15g8PSInvt/2Kv4nwna/532/UDAK2vL2MApw8KhmnzefMXh
	 6OK3COYVjTqWY2ploRamY3YtDgbrqUA+TpVZCT7mIIZiH/d+pHLuP86gb0tKgpyZaYAT7
	 WaWOtWX1B409YM2y/Ztlg45enwC9wxRv8QjGKcgo1m/QhNn6vnnyif7vxjuZlKANlNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723569;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PVzXQ2RYaauL4WOwQ31wWF0ak8azJBeYTb0/1fqEAaE=;
	b=PNM+Itmmy7M4mayV++vtJNjJjoVsnkFBAT/eugWJ9kPZEwt0YKoYYfIGfvACg1I0b2BA
	 zd1CQyhi/tsMKuMoWk7PW7Yf9WsKvB4+oFh1xFIxPi96Rd4vc0NBKyEhFewcYpd7b0q/C
	 PgK0/pBlZ8Z99nC3Z1VYaiXJQQ1xf4Bx7J2ZJbYF/5usgnWaiI+XIMZlQpMc7wsLzWTth
	 m41m0JCoO48BEIj93JchI6y3Bfp4z7TWxWYgEPbAWpubSC+noKdQLOgVF7/g9wDYVNNAz
	 YtWL83lRTIl2NIY6l9+wSTxqLpin0PfJ0IGeYeym1Z9QhoTsfNqJV+oNdbgwM/nCyDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVhJ1DD9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BBB606A324;
	Tue,  3 Nov 2026 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVhJ1DD9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDA11F0093A;
	Tue,  3 Nov 2026 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723569;
	bh=PVzXQ2RYaauL4WOwQ31wWF0ak8azJBeYTb0/1fqEAaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UVhJ1DD92jYPTwpzTriuTDtiTfy2CiWCj00e/WHxiFzK5SizkQoQjACjofZdEkRZP
	 /h2VEIm+kUygQOqtLpjpVDBcFIgGczNemozZGLHLWZ98gtL11/DJeue0LAmAV80oqK
	 Gkp88uLQ1Zbnp3VQcebet61Eru0PVl+qmXpApM+w907bFe4Pn5cLBEGMMIt4G5r9wc
	 kMNT4uSHU3pniH2hFAbBkz3HFcS0NBxiJt6AF49IkRhv7BweULY7xTOWzhxjapxStV
	 13T5XX7epziOk9f3l0ipHmwn7AmS34/p/S95flIIpp7FDOU0Oub1D+wQ2uA2MCMCGR
	 VUE+rGcnTuZ4g==
Message-ID: <sashiko-outbox-195729@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 7/9] drivers: greybus: Add software SVC
 implementation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ayush Singh" <ayush@beagleboard.org>, "Jason Kridner" <jkridner@beagleboard.org>, robertcnelson@gmail.com, "Johan
 Hovold" <johan@kernel.org>, "Alex Elder" <elder@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>, =?utf-8?b?Qmo=?=
 =?utf-8?b?w7ZybiBSb3kgQmFyb24=?= <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>, "Alexandre
 Courbot" <acourbot@nvidia.com>, =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Eric
 Biggers" <ebiggers@kernel.org>, "Ard Biesheuvel" <ardb@kernel.org>, "Ayush
 Singh" <ayush@beagleboard.com>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Markus
 Probst" <markus.probst@posteo.de>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261103-gb-uart-transport-v5-7-f8e326d6561f@beagleboard.org>
References: <20261103-gb-uart-transport-v5-0-f8e326d6561f@beagleboard.org>
 <20261103-gb-uart-transport-v5-7-f8e326d6561f@beagleboard.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 16:32:47 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] greybus: gb_softsvc: unsynchronized async SVC handshake in init() =
and drop()
- [Medium] greybus: gb_softsvc: unchecked response result in GbHdDriver::sv=
c_handler()
- [Low] greybus: gb_softsvc: commit message describes outdated NodeOps API
--

commit ee105f38d9a9f65cae00900a000f4081ef4dbafb
Author: Ayush Singh <ayush@beagleboard.org>

drivers: greybus: Add software SVC implementation

This commit adds gb-softsvc, an in-kernel software implementation of a
Greybus Supervisory Controller (SVC) in Rust for transports that do not
have a hardware SVC on the bus.

>     drivers: greybus: Add software SVC implementation
>    =20
>     A Greybus network requires an SVC (Supervisory Controller) to bring
>     interfaces up, assign device IDs and connect CPorts to the AP. On a
>     UniPro network the SVC is a real entity on the bus, but transports th=
at
>     merely carry Greybus messages - a UART, an I2C bus, a network link -
>     have no such entity, so every host driver for those transports ends up
>     open-coding an SVC emulation of its own.
>    =20
>     Add gb-softsvc, a Rust implementation of the SVC that lives in the
>     kernel and registers itself as a Greybus host device. It answers the
>     SVC-side operations the core expects during interface bring-up and
>     teardown.
>    =20
>     Host drivers use it through a small in-kernel interface. A driver
>     implements the NodeOps trait to send data towards its node and then
>     calls module_insert() to announce a new node, submit_message() to hand
>     incoming Greybus messages back to the core, and module_remove() on
>     disconnect. Interface IDs are allocated by the SVC and returned from
>     module_insert().
>    =20
>     Connection create/destroy and interface activate/resume currently just
>     acknowledge the request; callbacks into NodeOps can be added later if
>     transports need to act on them.
>    =20
>     gb_softsvc_exports.c exports the Rust symbols for dependent modules, =
as
>     the build system does not yet support Rust cross-module dependencies
>     natively. This hack is taken from nova-core [0].
>    =20
>     [0]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773fc=
977@nvidia.com/
>    =20
>     Signed-off-by: Ayush Singh <ayush@beagleboard.org>

[Severity: Low]
As reported by Sashiko on v4 [1], does the commit message still describe an
older version of the public API?

The changelog states that host drivers implement NodeOps and call
module_insert() (to obtain allocated interface IDs) and module_remove(). In
drivers/greybus/gb_softsvc.rs, the public trait is InterfaceOps,
module_insert() and module_remove() are private methods on Svc, and drivers
use Module::new(), Module::submit_message() with a module-relative interface
index, and Drop for Module.

> diff --git a/drivers/greybus/gb_softsvc.rs b/drivers/greybus/gb_softsvc.rs
> new file mode 100644
> index 0000000000000..c9bff6a5fa658
> --- /dev/null
> +++ b/drivers/greybus/gb_softsvc.rs

[ ... ]

> @@ -0,0 +1,533 @@
> +            (
> +                false,
> +                protocols::GB_SVC_TYPE_INTF_UNIPRO_ENABLE
> +                | protocols::GB_SVC_TYPE_INTF_UNIPRO_DISABLE,
> +            ) =3D> self.0.intf_unipro_enable_disable(hd, hdr),
> +            (false, protocols::GB_SVC_TYPE_INTF_ACTIVATE) =3D> self.0.in=
tf_activate(hd, msg),
> +            (false, protocols::GB_SVC_TYPE_INTF_RESUME) =3D> self.0.intf=
_resume(hd, msg),
> +            (true, protocols::GB_SVC_TYPE_PROTOCOL_VERSION) =3D> self.0.=
send_svc_hello(hd)?,
> +            (true, protocols::GB_SVC_TYPE_SVC_HELLO) =3D> {
> +                let global_state =3D GlobalState::new(self.0.clone(), hd=
.into());
> +                let _ =3D GLOBAL_STATE.lock().replace(global_state);
> +            }

[Severity: Medium]
Should GbHdDriver::svc_handler() verify that the response header result is
GB_OP_SUCCESS before advancing the handshake and populating GLOBAL_STATE?

In drivers/greybus/operation.c, gb_operation_request_handle() always calls
gb_operation_response_send(operation, status) for non-unidirectional reques=
ts:

drivers/greybus/operation.c:gb_operation_response_send() {
    ...
    /* Fill in the response header and send it */
    operation->response->header->result =3D gb_operation_errno_map(errno);

    ret =3D gb_message_send(operation->response, GFP_KERNEL);
    ...
}

If gb_svc_version_request() or gb_svc_hello() fails in drivers/greybus/svc.=
c,
the core still sends a response over GB_SVC_CPORT_ID with a non-zero error
code in header->result and leaves svc->state uninitialized. Because
GbHdDriver::svc_handler() only matches on (hdr.is_response(),
hdr.request_type()), it will treat the failed response as a success and
publish an uninitialized SVC in GLOBAL_STATE.

> +            (
> +                true,
> +                protocols::GB_SVC_TYPE_MODULE_INSERTED | protocols::GB_S=
VC_TYPE_MODULE_REMOVED,
> +            ) =3D> {}
> +            (false, ty) =3D> {
> +                dev_warn!(hd.as_ref(), "unsupported request 0x{:02x}\n",=
 ty);
> +                let rsp =3D Msg::response(hdr, protocols::GB_OP_PROTOCOL=
_BAD, ());
> +                hd.data_rcvd(protocols::GB_SVC_CPORT_ID, rsp.as_bytes());
> +            }
> +            (true, ty) =3D> dev_warn!(hd.as_ref(), "unexpected response =
0x{:02x}\n", ty),
> +        };
> +
> +        Ok(())
> +    }
> +}

[ ... ]

> +impl kernel::Module for GreybusSoftSvc {
> +    fn init(_module: &'static ThisModule) -> Result<Self> {
> +        pr_info!("gb_softsvc (init)\n");
> +
> +        // SAFETY: This runs once at module init, before anything else c=
an reach `GLOBAL_STATE`.
> +        unsafe { GLOBAL_STATE.init() };
> +
> +        let faux =3D faux::Registration::new(c_str!("gb-softsvc"), None)=
?;
> +        let svc =3D Arc::pin_init(Svc::new(), GFP_KERNEL)?;
> +        let data =3D GbHdDriver(svc.clone());
> +
> +        let dev =3D faux.as_ref().as_ref();
> +        let hd =3D hd::Registration::new(dev, GB_OPERATION_SIZE_MAX, CPO=
RT_ID_MAX + 1, Ok(data))?;
> +
> +        svc.send_version(hd.as_ref())?;
> +
> +        Ok(GreybusSoftSvc {
> +            _hd: hd,
> +            _faux: faux,
> +        })
> +    }
> +}
> +
> +impl Drop for GreybusSoftSvc {
> +    fn drop(&mut self) {
> +        let _ =3D GLOBAL_STATE.lock().take();
> +        pr_info!("gb_softsvc (exit)\n");
> +    }
> +}

[Severity: High]
Because the SVC handshake runs asynchronously on svc->connection->wq, can
GreybusSoftSvc::init() and GreybusSoftSvc::drop() race with the handshake w=
ork
items?

In GreybusSoftSvc::init(), svc.send_version() calls hd.data_rcvd() ->
greybus_data_rcvd() -> gb_connection_recv_request(), which only queues the
incoming GB_SVC_TYPE_PROTOCOL_VERSION request onto svc->connection->wq.
GreybusSoftSvc::init() returns before that work item and the subsequent
GB_SVC_TYPE_SVC_HELLO request complete and populate GLOBAL_STATE in
GbHdDriver::svc_handler(), so a consumer calling Module::new() right after
module init will see GLOBAL_STATE as None and fail with EAGAIN:

    pub fn new(intfs: &[Arc<dyn InterfaceOps>]) -> Result<Self> {
        ...
        let guard =3D GLOBAL_STATE.lock();
        let state =3D guard.as_ref().ok_or(code::EAGAIN)?;

In addition, when GreybusSoftSvc is dropped, GreybusSoftSvc::drop() runs
GLOBAL_STATE.lock().take() before its _hd field is dropped via
Registration::drop() -> gb_hd_del() -> gb_svc_del() ->
gb_connection_disable_rx(). If the asynchronous GB_SVC_TYPE_SVC_HELLO respo=
nse
is processed on svc->connection->wq after GreybusSoftSvc::drop() clears
GLOBAL_STATE but before _hd is unregistered, GbHdDriver::svc_handler() will
reinstall GlobalState into GLOBAL_STATE and leak the Arc<Svc> and
ARef<hd::Device> references.

[1] https://lore.kernel.org/r/20261021-gb-uart-transport-v4-4-c308ce821d45@=
beagleboard.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-gb-uart-tr=
ansport-v5-0-f8e326d6561f@beagleboard.org?part=3D7
