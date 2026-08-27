Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AFF306775
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 07:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817295; cv=none; b=DACQr8Q1tDYIETDMMeE6J0/mESlGZDb0ZB9grTKHGqfqeTTN5UKBaYvSO4zCJZgI5Am3ailj20kVski08bQMPJNEvcfITohkK555Yq0VUHTBxNuO0E5wwoOVVc/tWCIoi9hKzT0h1XU2/Q/VGtx0UL3zbpnXBPPySNwQAkptB5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817295; c=relaxed/simple;
	bh=O07296HIjH3sXW22U+nMby2Sc/yzcqX5nvs3bBNIq0w=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=BEPl6OVHOh89XgydGO68n2Qm2bAMTgxU0hE3BU2xQdbWIJjvohdw/n+0nFadFDm+9d9K+qzuxN2/nYvVZWeqqBlkV27UzKozXwu7GF+qZcKNk2R8FpDMcJ7T6ytOMPpTs8lBZ3q6Yq/sMaxZhW8wE0LfZWVcHCEhoSa+p58qPok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=E+He/nfO; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="E+He/nfO"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-39652a6e963so670252a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 00:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1787817293; x=1788422093; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RVJCcBAuS3izuvlvZhdPsxJ3W7iR8P4cqbeVqoSeh+Q=;
        b=E+He/nfOyc+FYMfO8KTuXBVuOgH80tcM2eFsKs01FvEx4kX+MOQhEQ5OownVKsL+CD
         W0FwL0OVmYi0xdE4ElRn7bE21kBTOiVG3dCqK5NFAk8VoQ2JAt0i92f0vCKifzdE4jlT
         XBFwwMAEQWzNwDDkMKR54R9JMAUGTo5JKcBIN1OeOKZnBPJ0OoNZpRWOxXfz5oGOMMFc
         S4XJEwdiSb9WNxhvZzIm130yXmh7v4d26eEd3m461Cb3Y96hlrGGop0Nu+jpBDLDaHaX
         e/4xrsl2BBwtTfiFT8nBRrQ16xc5VRI0WDNwGq4OBUYEw4d1uG/DZdhl2Swx6r5UQbrk
         vKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787817293; x=1788422093;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RVJCcBAuS3izuvlvZhdPsxJ3W7iR8P4cqbeVqoSeh+Q=;
        b=WLBufIQ5UPeRzJ0lUjpVpHtctgJR2XX41NPtV0wqLTOF/HQaQkEpIsrNzkDYPhxPg6
         rqedFLsOnNKVWeT9FsxoBkFo+1G6lTEdpeiDVvLFveIWUG93iWXt9yDmLbuPwnfcoUXe
         8n8MmP4L/T6gZg16Q9OYE28ILLYYix9ciEy7r0RLhWsJa/Kp7/rCvVGTOqZ2OuHQUpZ/
         XJVYtwoSjg03RksxXe08D5xjJw9u364D9Qs0EPXpy+LVT82+hMLSafIiH2G6EDqs4r4+
         xb+nr7hR45MgxPa1jAsrT/RVSNAeK8yiZNSGKvKdY1U+kobGCGkBBg8IEDzBRz5y0N29
         V/sg==
X-Forwarded-Encrypted: i=1; AHgh+RrlNtMyw5T0vVMEpgIO4QwCxNIt6RjcuVpUMhcIAojeDXccrDg6hgbzZcqEBYiENYYTrIpPeRsxYZ9woTY=@vger.kernel.org
X-Gm-Message-State: AFuF++kbZ2BFYBwyX1P7kl2Nc9JaT8QxKYHugH/I3iXRTfmiZZMZMJBm
	U/HpobEx8kxZ+kk2vB55zZ9gdgHKvbkoTa0MNIBfygQFLVih8xhz+J5agZxyZAABaQ==
X-Gm-Gg: AR+sD120nqFzBHtAR9jCaA1aPkK6J9aMkLBRu+asUU1/G2LwZftjoDrhgQQkWl5zCPX
	41lj89eApyHgyRA1rRsZv9sl0U9LRYFfS2WfByR98t3NUMZUjR4ypNPtNoWj/ghDpyvnMPJh1we
	gUoY8u97CsR5iSM5dGeiWk5MsyNX949o+jgiYqxLdo79cUeX8UzL+EoWEn6kuKedbdEfokV1o/F
	63wjvxIlVzaI8C7m600P0u6af4cqk/JzfdfoVcrB73OIp21YwRKNHZYrD/yzErrjnjTHQqYINuE
	Z0KdHDNbzeCp038Ck56Z7ByY1NArHHpebMPldp1Y8qo1ylBMsOox7f8mzfwnIRpQymobCr7F2FU
	tCy3db7wDKZUnp3a2VlmFLfXhY1TkPnV9mIl+lVUrBIQD/WHY6gtB2d16qygfXxmdWIbfOlq4lS
	cK50XpZJzSw+oNhm96uLBG/fjaCrP6bLHurl9BPxWFSuK8av89lM2TYmmRY+Ok5plaJDY4Zt4=
X-Received: by 2002:a17:90b:35d1:b0:396:65b3:c05e with SMTP id 98e67ed59e1d1-3969bb1e82bmr6537161a91.9.1787817292922;
        Thu, 27 Aug 2026 00:54:52 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d60c2b4sm24641685eec.5.2026.08.27.00.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:54:52 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Subject: [PATCH v2 0/7] Add Greybus Sotfsvc and UART Node drivers
Date: Thu, 27 Aug 2026 13:24:36 +0530
Message-Id: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NwQrCMBBEf6Xs2UiyNG315H9ID5tmTQPSyKYWp
 fTfjcWjt3kD82aFzBI5w7laQXiJOaapAB4qGEaaAqvoCwNqbHRntApOPUlmNQtN+ZFKOqG1vrG
 2HeoByu4hfIuv3XntC48xz0ne+8Vivu3Phv9si1FaYYeeTE2ude3FMYU7u0Tij0kC9Nu2fQBq4
 iBWuAAAAA==
X-Change-ID: 20260810-gb-uart-transport-9255d6557c4c
To: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, 
 Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8005; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=O07296HIjH3sXW22U+nMby2Sc/yzcqX5nvs3bBNIq0w=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqj+1Cc6huTwI+9sLozSbo/yQUuyB4CH+Y+POwV
 /Rliv0OTdKJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCao/tQgAKCRAFzvXHieVa
 dBQlD/4iQuLDaYSy2Gi4Nqd6vbpyJrRFxtM5rQV53gnnPPTc9C//rc6uZe5sSqr5fDP0Sgx9VPa
 it2YlMxbuMlItKYUG3DeN52ddmZZHy+MX9xv/N720oJCE10hkDXtVqGJmsx8r5eKkrNmdGwHkQV
 YyP46EDliEeLzLTnM2AmXXGRwHEziNJPI2ckHjcaAC3c3gHqdncj8LjmWnPswISsYL3hoj9xrk3
 vHdD4S42JcUL5khXp7bdBymoRDDzTbmE0UNpZhC9va0n5elBh5qnkmlKwLgNkt1KeMvoRQoey/l
 f/twbtyraYgy1W8xgCW+L4FeF5sO01CWRJMjSASpj8mL9v9RLDg7lihVjh6BVdLwI8ULj3yW+nG
 sRPQ3y4vwHh7WsTV048vbTptoAA5mMZxRLL8OocRvz0GImg7CcV0AQoX/GRQL/hwk1q7TGWmnyb
 0PeialWIe12vUZyH+fqa+lcTBvfhES3Lu58TBWGw5I1/xUF9WT1cYndvEoxBwMbhljdIYa8QVRQ
 8qRbiPblfYwbo6ItfOojrQB7bQHEGA38ItJEU/N9KGRv98a8hagwrx1ZgcwgCLCV95G2aQuVGfS
 Y1unhTGky6mWTNiCmnsoNcLIGZM8tO9ehj1x/Fqrl2lW+kGlunhgIpYsdrQj+HbyjE+m/FD40l6
 +eR35ZZFVPkkJqg==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

A Greybus network needs an SVC (Supervisory Controller) to bring
interfaces up, assign device IDs and connect CPorts to the AP. On a
UniPro network the SVC is a real entity on the bus. On transports that
merely carry Greybus messages - a UART, an I2C bus, a network link -
nothing on the wire plays that role, so the SVC has to be emulated
somewhere: in a user-space bridge (gbridge), in coprocessor firmware
(cc1352p7 in gb-beagleplay), or open-coded inside the host driver itself.

This series moves the emulation into the kernel and makes it shared.
This was discussed in a prior RFC as well [2], but to keep things short,
removing the need for an external SVC greatly simplifies the greybus
network setup when nodes are directly connected over common transports
such as UART, I2C etc.
 
    gb-uart-node          gb-softsvc              greybus core
   (transport, serdev) <-> (SVC + host device) <-> (bundles, protocols)
        NodeOps            module_insert()
     submit_message()      module_remove()

gb-softsvc registers itself as a Greybus host device and answers the
SVC-side operations the core expects during interface bring-up and
teardown. A host driver implements the NodeOps trait to push data
towards its node, calls module_insert() to announce a new node,
submit_message() to hand incoming Greybus messages back to the core,
and module_remove() on disconnect.

The first user is gb-uart-node, a driver for Greybus nodes attached over
a plain serial port. Framing is HDLC, with a one-byte address (0x01 for
Greybus) and control byte, followed by the 16-bit CPort ID and the
Greybus message. No SVC firmware is required on the far end, so the node
can be a bare microcontroller speaking Greybus - a BeagleConnect Freedom
over its serial link, in this case. The testing is performed with
greybus-zephyr [0] implementation.

Both drivers are written in Rust, which is why the middle of the series
is abstractions rather than drivers. Only the APIs these two drivers
need are covered: protocols.rs abstracts the SVC-facing parts of
greybus_protocols.h, and types such as Greybus Interface do not
implement AlwaysRefCounted yet. The intent is to grow this as more Rust
host drivers appear rather than to abstract the whole subsystem up
front.

Patches 1 and 2 are small C-side preparations to the Greybus core:
exporting gb_connection_get()/gb_connection_put() and adding
gb_connection_hd_find_by_intf(), a lookup by remote interface and CPort
id for callers that only know the far end of a connection. Patch 3 adds
a CRC-CCITT abstraction, needed for HDLC frame checks. Patch 4 adds the
Greybus abstractions, patches 5 and 6 the two drivers, and patch 7 the
device tree binding for BeagleConnect Freedom.

Open questions 
***************

- gb-uart-node imports types from gb-softsvc, so the series carries the
  Rust-to-Rust cross-module calling setup from nova-core [1]:
  gb_softsvc_exports.c plus the Makefile plumbing that emits crate
  metadata and generates the export list. This is a workaround for the
  build system not supporting Rust cross-module dependencies natively,
  and it should go away once that lands.

- Connection create/destroy and interface activate/resume in gb-softsvc
  currently just acknowledge the request. Callbacks into NodeOps can be
  added when a transport actually needs to act on them; I did not want
  to invent an interface without a user.

- Zerocopy is currently not being used in grebeybus/protocols.rs. They
  cannot be derived yet since types generated by bindgen do not have
  them, and it seems explicitly forbindden to manually impl the traits.
  So using old traits from transmute.

- The bindings are supposed to be created for actual device, but any MCU
  that supports Zephyr, can run the greybus-zephyr firmware with UART
  transport. So not sure if adding a beagle,beagleconnect-freedom
  compatible is the correct choice here.

- The individual patches can be spun off into independent patch series
  if required. The reason for this single patch series is to provide a
  complete picture of usage.

- Since gb-softsvc currently is not being used from a C driver, no C API
  is provided. However, if required, it can be added.

- Writing to UART from gb-uart-node is currently a bit broken. I am not
  quite sure what the safe way is to go from a non-bound device to a
  bound device. Any suggestions on this front are welcome.

- I am not sure if Rust abstractions should have a seperate entry in
  MAINTAINERS with me as the maintainer, or if they should just be added
  to the respective subsystem entries.

[0]: https://github.com/beagleboard/greybus-zephyr
[1]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773fc977@nvidia.com/
[2]: https://lore.kernel.org/all/ecca8eb2-8e5a-4770-bcf6-3fb49773088b@beagleboard.org/

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
Changes in v2:
- Fix possible null pointer dereference in
  gb_connection_hd_find_by_intf. Flagged by sashiko-bot.
- Remove prompt CONFIG_RUST_CRC_CCITT_ABSTRACTIONS Kconfig symbol.
- Add CONFIG_RUST_GREYBUS_ABSTRACTIONS to ensure that greybus is
  built-in for rust abstractions to work.
- Use gfp_mask in message_send callback.
- Only provide a Message reference in message_cancel callback.
- Add invariant comment for Registration.
- Call Registration->add directly in new, before constructing
  Registration.
- Add Send and Sync bounds to T in Registration<T>
- Set endo_id as 0. Is not used anywhere.
- Fix module_insert intf_count. Was hardcoded to 1 by mistake. Flagged by
  sashiko-bot.
- Check for empty intfs slice in Module::new.
- Remove module in serdev::Driver::unbind instead of on drop.
- Make gb_uart_node write atomic. Using temp buffer to build frame.
- Fix import style.
- Reorder beagleconnect-freedom dtbinding patch to be before gb_uart_node.
- Add vbat-supply and reg properties to beagleconnect-freedom dtbinding.
- Reference spi-peripheral-props in beagleconnect-freedom dtbinding.
- Link to v1: https://lore.kernel.org/r/20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org

---
Ayush Singh (7):
      greybus: connection: Export gb_connection_get() and gb_connection_put()
      greybus: connection: Add gb_connection_hd_find_by_intf()
      rust: crc_ccitt: add CRC-CCITT abstraction
      rust: kernel: Add greybus abstractions
      drivers: greybus: Add software SVC implementation
      dt-bindings: beagle: Add BeagleConnect Freedom
      greybus: Add Rust UART node driver

 .../beagle/beagle,beagleconnect-freedom.yaml       |  39 ++
 MAINTAINERS                                        |  15 +
 drivers/greybus/.gitignore                         |   1 +
 drivers/greybus/Kconfig                            |  34 ++
 drivers/greybus/Makefile                           |  50 ++
 drivers/greybus/connection.c                       |  29 +-
 drivers/greybus/gb_softsvc.rs                      | 504 +++++++++++++++++++++
 drivers/greybus/gb_softsvc_exports.c               |  15 +
 drivers/greybus/gb_uart_node.rs                    | 245 ++++++++++
 include/linux/greybus/connection.h                 |   6 +
 lib/crc/Kconfig                                    |   7 +
 rust/bindings/bindings_helper.h                    |   2 +
 rust/kernel/alloc.rs                               |   5 +
 rust/kernel/crc_ccitt.rs                           |  26 ++
 rust/kernel/greybus/hd.rs                          | 333 ++++++++++++++
 rust/kernel/greybus/mod.rs                         | 232 ++++++++++
 rust/kernel/greybus/protocols.rs                   | 392 ++++++++++++++++
 rust/kernel/lib.rs                                 |   4 +
 18 files changed, 1937 insertions(+), 2 deletions(-)
---
base-commit: 6b8c8af514d739d0335f5579b585e02babe8a727
change-id: 20260810-gb-uart-transport-9255d6557c4c

Best regards,
-- 
Ayush Singh <ayush@beagleboard.org>

