Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D341E4F68C6
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 12:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892883; cv=none; b=HMknORj2bEsDn24c3xiNWyZMy5chfgvpgjfxqxPSQ8FwwSnXW3cyMpg8c+ySHLyS9q6PZR4UN/AHdo1HR3AL7F8VeEJw8PlcTRL71AneHdjLasoMw99rSdaTJckxcEmtMUQjdfNBz+3agLy3lQlg7aFZEWREWba5pxxcRzQhVHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892883; c=relaxed/simple;
	bh=pyo2toKqcoI0V2I7DIShC1rOtlet+iA6Yb45xLXf6Fc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=KfaPdxtxL0EM8djwDwCJdfkkyahsRUcIqc66supkR3ETa/HTNioXXXbiNwHhKQMtFldaz0FIw3nlfDpU5VOMkN38o1t/l5pPjcaXdX8CEDM4pJIpPCJVL6rZcZKnvFgBCJHm5nuhCNFWBxxL7Rm4ZoDiGEOpHRnYJa1QrAcO+eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=S2xjK7G9; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="S2xjK7G9"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a80d1c98f5so1640640a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 05:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1791892880; x=1792497680; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m6MJg+My7Hvkr24UO8fsAEmv5TwdsJ245XYm9PwoCOk=;
        b=S2xjK7G9dEHgzmbXgkfTzCo7C7A79TXKVpYQw7rlrLxLFubTB09efHSiut1slTCEs0
         TFdOybsKQ41thaBN9AlhaZFGK4ELoXU8nIdOr+jC+DWBbb0Eq2+Yed58V4Mf9okPifzL
         1TCHlGQNJqi8bocmRXXREgaygqJXPpVh/TBPPct5gyEeITIScqjVGek9fj1qtBHGx7G4
         2/0ciqpQRmDEP84JUveM5Cyd8FXaq/vJUTFQjIQ3TclYYZhx4SVwX/9RUQnM1a4iuGo2
         F1/e/X5p+HUzSzmlLmg+mc1BQzMJqDtWnpCNraC2luV+/vQ5wr3KzR0uip3v9DzrHnE/
         y9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791892880; x=1792497680;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m6MJg+My7Hvkr24UO8fsAEmv5TwdsJ245XYm9PwoCOk=;
        b=yxkLtKKHm7wkeJaZ7sv6dsU6SpEmk7Y2Ol3Qm2h2RnZLEV9BRHSbzp6m/2RdIqBAAD
         BZT9gzasvh4qisp/ZIq4Xv8VAMlHosdaUVVMcwShRzR+b1Q/FuJv+cQYB8u40+2ibvxd
         i1KvDDLjHcwMB8qNw7dNEkHWEi2vuIoo4kCbpW+RcORnDF5aU8Eu4tpRbi7aKzrKCKFq
         dTK6Ox6Fs6+JNmmnsFBtJcgAKyVIZcZ7WOo9vtP/Wb6JMjK+XC9aoZNrNN863wX8L3Rv
         suuZU0AtC4YUSzOriFXwk78v6ucka5xc2Fu5jJfohYRDn1i82JOhBws7OXSFQeUHxrHt
         xPag==
X-Forwarded-Encrypted: i=1; AKwUvBxvWRQLj6zFVE2Oh4Cv81vR+JOLdmy3sYCQF3zLaiJZIZwOufQlrqKTO+RecZLU52TcC6N/gnecgJ9TiCY=@vger.kernel.org
X-Gm-Message-State: AFq9FYKoX4sKI50zye3nOTaQlIwRH3gPs4xWxzzU2NSr7bklPDzDsJJy
	z8UpVG1o2GDjx+pyjJbYliP5vmLlOpqAb5l6NP1BKYXRkAkxgh1cMwEh6/3JkaS7UA==
X-Gm-Gg: AYBFou3HALrxFhrShswhCMAAjhDt0+463EUvwiLPOMESOlqxx0Fg+YkxlWqxp5yaci9
	4PRsWsz28nwwSmGATFIJXStixnvQ2t+V74NgXsV9elv0kKTNbbayYULtT3uE7L8iieN1sY0qNnt
	fekDWobn7HALB64IK7n+BWoTKbcKd845DRWK4iN/o8yJWZIJXPIi7TM4Hp89bk3nonsuaF7OJIo
	sKnPX2cUruHTFOMq9QSRCIFX8H/P7EdMwTPkw7EJ/qVJdDaje1D+kw1E7rekK3ULYsES89GuD+O
	jk75CzUk3lUdPg5j8x4BbQTMnqX8A85hzGoDwIAFlinUGt2ZE1cduhDz6Ege19Ls4VXAjnydvTl
	8EiJWrVrMFzhnEn3ZTwRBkZWnhaPHe/wAKwurV1Cu0eeS1xVCm9pONv+uOO43PDmOvvpTO7/7jU
	1+T7qwOosXOr5YzWwnh3Qy368GV/C69fvpwQBfGs4KJ6aO07EXjwDNAITFJC3v5kWhw0tIV4hiG
	hzfDblkJw==
X-Received: by 2002:a17:90a:d2c7:b0:3ab:2d17:51c5 with SMTP id 98e67ed59e1d1-3ab3a32d9b3mr9916376a91.6.1791892879765;
        Tue, 13 Oct 2026 05:01:19 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab8a393666sm16566838a91.15.2026.10.13.05.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:01:19 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Subject: [PATCH v3 0/7] Add Greybus Sotfsvc and UART Node drivers
Date: Tue, 13 Oct 2026 17:30:38 +0530
Message-Id: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23NwQ6CMAyA4VcxOzuzFQboyfcwHlo2xhLDyIaLh
 vDuDuLBRG79m/TrzKIJzkR2OcwsmOSi80OO4nhgbY+DNdzp3AwEVKKRglviTwwTnwIOcfR5OoN
 SulKqbsuW5bsxmM69NvN2z927OPnw3l4kuW6/GuxpSXLBoQGNskSqqb6SQfsw5DHokw+WrWaCX
 6fecyA7KAoi2amOtPx3lmX5AKX7lzUAAQAA
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
 Uladzislau Rezki <urezki@gmail.com>, 
 Markus Probst <markus.probst@posteo.de>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>, 
 Conor Dooley <conor.dooley@microchip.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8591; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=pyo2toKqcoI0V2I7DIShC1rOtlet+iA6Yb45xLXf6Fc=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqzh2CLWuxfIEPdoLB0Rpy0whhsxktbmC1TRq8v
 lU6wQ4CTSaJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCas4dggAKCRAFzvXHieVa
 dJfLEADgfpTEVGe7KlgUz7QQmoWDQ62DdyEaKFt17G5HXn2SeP0veTXCEOEhPSQ6dCp0dnv+/xM
 g3BazRz89BAN6VUox85Xk8PcBqjr802UHmcFmiANnRDh9hlqXAJj64W49vGGib0158HA+QClgww
 AIEf1p9a7mKEeBe5qTkOePtx21zWR4xPTBCjn1F1Q6F00qdc5/8bzC7u2v1WvQCnv0Jn0qh+iY1
 ZvCY+o0WcuCS+cgUvtbgF5ZMEtAjysarAhT0DRwLCNyfS7vuuQd1qRBQxbOC7gtx7ydpOCNsrzG
 YfyCwVlUqXq+3vFLfGA62zERFoOQ1h5Yg85PO1E6BHDjFz6GAyuAbCoCRiRZ92qtuSH6M834d2g
 HufhzMmPdCUKQ+idiJDnQu9Rx53Ye+ZlI/pNI/L2b69KYzdL0OEra98LEto1xFkYonWrteBX4Nz
 iakVvZa2li4ieFsgHSNVs6q0Eq9dH4whQFJ9MmykAI9H489XTixxQHcMcAsKQdhgz4Kle3erXS9
 yNe2O1VW9XXCSbKoXRpghq3W7zGoCWSMWs1t0Izk/4QPzydhLypE2DZxOg5Qhfj4rzAdBgD8hrb
 9eEapkpCt8XeE3AY6mxCCHneqvsPaOyKZV/O5YdQeUcplb4do5sRoNQDBZiWOwZURLdbhkotCgC
 SmNYHxmb3Ij0pfg==
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
Changes in v3:
- Fix incorrect email in MAINTAINERS.
- Make CONFIG_RUST_GREYBUS_ABSTRACTIONS depend on sysfs like
  CONFIG_GREYBUS.
- Fix cleanup in hd::Registration::new in case of errors.
- Fix comments.
- Fix Msg AsBytes impl as suggested by sashiko-bot.
- Use SpinLock for intf_map. This should be fine since we need locking
  only for getting the interface. We do not hold locks across operations.
- Properly drop message in case of buffer overflow in gb_uart_node.
- Link to v2: https://lore.kernel.org/r/20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org

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
 drivers/greybus/Kconfig                            |  35 ++
 drivers/greybus/Makefile                           |  50 ++
 drivers/greybus/connection.c                       |  29 +-
 drivers/greybus/gb_softsvc.rs                      | 517 +++++++++++++++++++++
 drivers/greybus/gb_softsvc_exports.c               |  15 +
 drivers/greybus/gb_uart_node.rs                    | 253 ++++++++++
 include/linux/greybus/connection.h                 |   6 +
 lib/crc/Kconfig                                    |   7 +
 rust/bindings/bindings_helper.h                    |   2 +
 rust/kernel/alloc.rs                               |   5 +
 rust/kernel/crc_ccitt.rs                           |  26 ++
 rust/kernel/greybus/hd.rs                          | 342 ++++++++++++++
 rust/kernel/greybus/mod.rs                         | 232 +++++++++
 rust/kernel/greybus/protocols.rs                   | 444 ++++++++++++++++++
 rust/kernel/lib.rs                                 |   4 +
 18 files changed, 2020 insertions(+), 2 deletions(-)
---
base-commit: becb95e45ef0dda9ffb35156d909d3da7a2789c3
change-id: 20260810-gb-uart-transport-9255d6557c4c

Best regards,
-- 
Ayush Singh <ayush@beagleboard.org>

